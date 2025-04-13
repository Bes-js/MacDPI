import { app, BrowserWindow, ipcMain, Tray, Menu, Notification, dialog } from "electron";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

import os from "os";
import { exec } from "child_process";

/* Engine */
import { 
  checkSpoofDPIInstalled, 
  installSpoofDPI,
  DPIEngine
} from "./utils/engine";

/* Language */
import language from "./utils/language";

/* Store */
import { JsonDatabase } from "five.db";
import { Language, Preferences } from "./types";

const store = new JsonDatabase({
  databasePath: join(app.getPath("userData"), "store.json"),
});
export { store };

var mainWindow: BrowserWindow | null = null;
var engine: DPIEngine | null = null;
var tray: Tray | null = null;
var macModel = "";
var macConnectionType = "";

const createWindow = (isHide?: boolean) => {
  var window = new BrowserWindow({
    width: 600,
    height: 400,
    show: !isHide,
    title: "MacDPI",
    icon: join(__dirname, "../public", "active.png"),
    center: true,
    frame: false,
    resizable: false,
    fullscreenable: false,
    autoHideMenuBar: true,
    vibrancy: 'under-window',
    visualEffectState: 'active',
    transparent: true,
    titleBarStyle: 'hidden',
    minimizable: false,
    maximizable: false,
    movable: true,
    trafficLightPosition: {
      x: 10,
      y: 10,
    },
    titleBarOverlay: {
      color: '#000000',
      height: 91
    },
    webPreferences: {
      preload: join(__dirname, "preload.js"),
      nodeIntegration: true,
    },
  });

  window.on('blur', () => {
     window.hide();
  });

  window.on('close', (event) => {
    event.preventDefault();
    window.hide();
  });

  window.on("closed", () => {
    mainWindow = null;
  });



  /* mainWindow.on("ready-to-show", () => mainWindow.show()); */

  const loadURL = async () => {
      try {
       
        window.loadFile(join(__dirname, "../out/index.html"));
      } catch (error) {
        console.error("Error starting Next.js server:", error);
      }
  };

  loadURL();
  return window;
};



const sendLanguage = () => {
    mainWindow?.webContents.send("getLanguage", (store.get('language') as Language.Codes || 'en'));
};


const sendInformation = async () => {
  const isDPIActive = store.get('isDPIActive') as boolean || false;

  fetch("http://ip-api.com/json").then((response) => {
    if (response.ok) {

      response.json().then((data) => {
        const informations = {
          connection: isDPIActive,
          isp: data.isp,
          colocationCenter: data.country + "/" + (data?.city || data?.regionName),
          connectionType: macConnectionType,
          publicIP: data.query,
          deviceInformation: macModel,
        };
        mainWindow?.webContents.send("getInformations", informations);
      });

    }
  }).catch((error) => {
    console.error("Error fetching data:", error);
  });
        
};


app.whenReady().then(async() => {

  app.dock?.hide();
  if (!(await checkSpoofDPIInstalled())) {
    var dialogLang = process.env.LANG?.split(".")[0].split("_")[0];
    var getDialogLang = language[dialogLang as Language.Codes] || language.en;

    const install = await dialog.showMessageBox({
      type: 'info',
      title: getDialogLang.dialog.needSpoofTitle,
      message: getDialogLang.dialog.needSpoofDescription,
      buttons: [getDialogLang.yes, getDialogLang.no],
      icon: join(__dirname, "../public", "cloud.png"),
    }).catch((error) => { });

    if (install?.response == 0) {
      var installResponse = await installSpoofDPI().catch((error) => { });
      if (installResponse) {

        new Notification({
          title: getDialogLang.dialog.spoofInstallTitle,
          body: getDialogLang.dialog.spoofInstallDescription,
          icon: join(__dirname, "../public", "cloud.png"),
          subtitle: getDialogLang.app.name,
          silent: false,
          timeoutType: 'default',
          hasReply: false,
          urgency: 'normal',
        }).show();

        app.quit();
        app.relaunch();
      };

    } else {
      app.quit();
    };

  } else {

  mainWindow = createWindow(true);
  await listenIpcMain().catch((error) => { });
  await initalizeMacInformations().catch((error) => { });
  tray = createTray();

  const isDPIActive = store.get('isDPIActive') as boolean || false;

  engine = new DPIEngine();

  if (isDPIActive) {
  await engine.startDPI().catch((error) => {});
  };
  

  }

});

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});




/* Create Tray */
function createTray() {
  const appLanguage = store.get('language') as Language.Codes || 'en';
  var preferences = store.get('preferences') as Preferences.ListType || {
    showTitle: true,
    notifications: true,
    launchAtLogin: false,
  };
  const isDPIActive = store.get('isDPIActive') as boolean || false;
  

  const trayMenu = new Tray(
    isDPIActive ?
    join(__dirname, "../public", "active.png") :
    join(__dirname, "../public", "deactive.png"));
  trayMenu.focus();
  trayMenu.setToolTip('MacDPI');
  trayMenu.setTitle(preferences.showTitle ? isDPIActive ? 'Mac\x1b[32mDPI\x1b[0m' : 'Mac\x1b[31mDPI\x1b[0m' : '');
  trayMenu.setContextMenu(createContextMenu(appLanguage,preferences,isDPIActive, trayMenu));

  return trayMenu;
}


/* Create Context Menu */
function createContextMenu(
    lang: Language.Codes,
    preferences: Preferences.ListType,
    isDPIActive: boolean,
    tray?: Tray
  ) {
  const selectedLang = language[lang] || language.en;

  return Menu.buildFromTemplate([
    {
      label: isDPIActive ? selectedLang.turn.off : selectedLang.turn.on,
      accelerator: 'Command+Shift+I',
      type: 'checkbox',
      icon: join(__dirname, "../public", `toggle-${isDPIActive ? 'on' : 'off'}.png`),
      click: async(item) => {
          item.label = isDPIActive ? selectedLang.turn.on : selectedLang.turn.on;

          if (isDPIActive) {
            await stopDPI(tray).catch((error) => { });
          } else {
            await startDPI(tray).catch((error) => { });
          }

          tray?.setContextMenu(createContextMenu(lang, preferences, !isDPIActive, tray));

          await sendInformation().catch((error) => { });
      }
    },
    { type: 'separator' },
    {
      label: selectedLang.app.settings,
      icon: join(__dirname, "../public", "tools.png"),
      click: () => {
        mainWindow?.show();
        mainWindow?.focus();
      }
    },
    { type: 'separator' },
    {
      type: 'submenu',
      label: selectedLang.language,
      icon: join(__dirname, "../public", "earth.png"),
      submenu: selectedLang.languages.map((langs) => ({
        label: langs.name,
        type: 'radio',
        checked: lang == langs.code,
        click: () => {
          store.set('language', langs.code);
          tray?.setContextMenu(createContextMenu(langs.code as Language.Codes, preferences, isDPIActive, tray));
          sendLanguage();
        }
      }))
    },
    {
      type: 'submenu',
      label: selectedLang.app.preferences,
      icon: join(__dirname, "../public", "chart.png"),
      submenu: [
        {
          type: 'checkbox',
          label: selectedLang.app.preferencesList.showTitle,
          checked: preferences.showTitle,
          icon: join(__dirname, "../public", `toggle-${!preferences.showTitle ? 'on' : 'off'}.png`),
          click: (item) => {
            item.checked = !item.checked;
            
            store.set('preferences', {
              ...preferences,
              showTitle: !item.checked
            });

            tray?.setTitle(!item.checked ? isDPIActive ? 'Mac\x1b[32mDPI\x1b[0m' : 'Mac\x1b[31mDPI\x1b[0m' : '');
            tray?.setContextMenu(createContextMenu(lang, {
              ...preferences,
              showTitle: !item.checked
            }, isDPIActive, tray));
          }
        },
        {
          type: 'checkbox',
          label: selectedLang.app.preferencesList.notifications,
          checked: preferences.notifications,
          icon: join(__dirname, "../public", `toggle-${!preferences.notifications ? 'on' : 'off'}.png`),
          click: (item) => {
            item.checked = !item.checked;
            store.set('preferences', {
              ...preferences,
              notifications: !item.checked
            });
            
            tray?.setContextMenu(createContextMenu(lang,{
              ...preferences,
              notifications: !item.checked
            }, isDPIActive, tray));
          }
        },
        {
          type: 'checkbox',
          label: selectedLang.app.preferencesList.launchAtLogin,
          checked: preferences.launchAtLogin,
          icon: join(__dirname, "../public", `toggle-${!preferences.launchAtLogin ? 'on' : 'off'}.png`),
          click: (item) => {
            item.checked = !item.checked;
            store.set('preferences', {
              ...preferences,
              launchAtLogin: !item.checked
            });
            app.setLoginItemSettings({
              openAtLogin: true,
              name: 'MacDPI',
              serviceName: 'MacDPI',
              type: "mainAppService",
              enabled: !item.checked,
            });
            
            tray?.setContextMenu(createContextMenu(lang,{
              ...preferences,
              launchAtLogin: !item.checked
            }, isDPIActive, tray));
          }
        },
        { type: 'separator' },
        {
          label: selectedLang.app.resetPreferences,
          icon: join(__dirname, "../public", "reset-filter.png"),
          click: () => {
            store.set('preferences', {
              showTitle: true,
              notifications: true,
              launchAtLogin: false,
            });
            tray?.setContextMenu(createContextMenu(lang,{
              showTitle: true,
              notifications: true,
              launchAtLogin: false,
            }, isDPIActive, tray));
          }
        }
      ]
    },
    { type: 'separator' },
    {
      type: 'submenu',
      label: selectedLang.app.about,
      icon: join(__dirname, "../public", "information.png"),
      submenu: [
        { 
          label: selectedLang.app.about, 
          icon: join(__dirname, "../public", "information.png"),
          click: async () => {
            dialog.showMessageBox({
              title: selectedLang.app.about,
              message: `
              ${selectedLang.app.name} \n MacDPI \n\n ${selectedLang.app.version} \n ${app.getVersion()} \n\n ${selectedLang.app.aboutList.author} \n Berkant (Bes-js) Özdemir \n https://github.com/Bes-js \n\n`,
              type: 'info'
            });
          }
        },
        { label: selectedLang.app.aboutList.version + " " + app.getVersion(), enabled: false, icon: join(__dirname, "../public", "corner.png") },
      ]
    },
    { type: 'separator' },
    {
      label: selectedLang.exit,
      accelerator: 'Command+Q',
      icon: join(__dirname, "../public", "door.png"),
      click: () => {
        if (app) {
          console.log("Quitting application...");
          app.quit();
          app.exit();
        } else {
          console.error("Error: Application is undefined.");
        }
      }
    }
  ]);
}


async function getMacModel(): Promise<string> {
  return new Promise((resolve, reject) => {
  var model = "";
  exec('system_profiler SPHardwareDataType', (error:any, stdout:any, stderr:any) => {
    if (stderr || error) return;

    const output = stdout.toString();
    const modelMatch = output.match(/Model Name: (.+)/);
    const ChipMatch = output.match(/Chip: (.+)/);
    if (modelMatch) {
      model = `${modelMatch[1]?.trim()}${
        ChipMatch ? ` (${ChipMatch[1]?.replace('Apple','')?.trim()})` : ''
      }`;
    } else {
      model = `${os.hostname().split('.')[0]}`;
    }

    resolve(model);
  });
  });
};


async function getMacConnectionType(): Promise<string> {
  return new Promise((resolve, reject) => {
      exec('system_profiler SPAirPortDataType', (error, stdout, stderr) => {
        if (stderr || error) {
          console.error('Hata:', error || stderr);
          return;
        }
    
        const output = stdout.toString();
        if (output.includes("Wi-Fi")) {
          resolve('Wi-Fi');
        } else if (output.includes("Ethernet")) {
          resolve('Ethernet');
        } else {
          resolve('???');
        }
      });
    });
};

async function initalizeMacInformations() {
  try {
    macModel = await getMacModel();
    macConnectionType = await getMacConnectionType();
  } catch (error) { };
};



async function listenIpcMain() {

  /* Language */
  ipcMain.on("getLanguage", () => {
    sendLanguage();
  });

  /* Informations */
  ipcMain.on("getInformations", () => {
    sendInformation();
  });

  /* Proxy */
  ipcMain.on("setProxy", async (event, data) => {
    store.set('proxy', data);
    await restartDPI(tray).catch((error) => { });
  });

  ipcMain.on("getProxy", (event) => {
    mainWindow?.webContents?.send('getProxy',store.get('proxy') || {
      address: '127.0.0.1',
      port: 8080,
      useDefaultAddress: true,
      useDefaultPort: true
    });
  });

  /* DNS */
  ipcMain.on("setDNS", async (event, data) => {
    store.set('DNS', data);
    await restartDPI(tray).catch((error) => { });
  });

  ipcMain.on("getDNS", (event) => {
    mainWindow?.webContents?.send('getDNS',store.get('DNS') || {
      service: 'google',
      address: '8.8.8.8',
      port: 53,
    });
  });

  /* Patterns */
  ipcMain.on("setPattern", async (event, data) => {
    store.set('pattern', data);
    await restartDPI(tray).catch((error) => { });
  });

  ipcMain.on("getPattern", (event) => {
    mainWindow?.webContents?.send('getPattern',store.get('pattern') || []);
  });

  /* Advanced Options */
  ipcMain.on("setAdvanced", async (event, data) => {
    store.set('advanced', data);
    await restartDPI(tray).catch((error) => { });
  });

  ipcMain.on("getAdvanced", (event) => {
    mainWindow?.webContents?.send('getAdvanced',store.get('advanced') || {
      dnsIPv4Only: false,
      dnsOverHttps: true,
      systemProxy: true,
      useProxy: false,
      timeout: 5,
      clientHelloChunkSize: 1,
    });
  });


};


async function stopDPI(tray: Tray | null | undefined): Promise<boolean> {
  return new Promise(async (resolve) => {
    if (!tray) return resolve(false);

    try {
      tray.setImage(join(__dirname, "../public", "restart.png"));
      tray.setTitle('Mac\x1b[33mDPI\x1b[0m');

      const stopResponse = await engine?.stopDPI();
      if (!stopResponse) return resolve(false);

      store.set('isDPIActive', false);

      tray.setImage(join(__dirname, "../public", "deactive.png"));
      tray.setTitle('Mac\x1b[31mDPI\x1b[0m');

      tray.setContextMenu(
        createContextMenu(
          store.get('language') as Language.Codes,
          store.get('preferences') as Preferences.ListType,
          false,
          tray
        )
      );

      resolve(true);
    } catch (err) {
      console.error("Unhandled error in stopDPI:", err);
      resolve(false);
    }
  });
}


async function startDPI(tray: Tray | null | undefined): Promise<boolean> {
  return new Promise(async (resolve) => {
    if (!tray) return resolve(false);

    try {
      const isDPIActive = store.get('isDPIActive') as boolean || false;

      tray.setImage(join(__dirname, "../public", "restart.png"));
      tray.setTitle('Mac\x1b[33mDPI\x1b[0m');

      const startResponse = await engine?.startDPI();
      

      if (!startResponse) {
        await stopDPI(tray);
        return resolve(false);
      }

      await new Promise((resolve) => { setTimeout(resolve, 2000); });

      const newState = true;
      store.set('isDPIActive', newState);

      tray.setImage(join(__dirname, "../public", "active.png"));
      tray.setTitle('Mac\x1b[32mDPI\x1b[0m');

      tray.setContextMenu(
        createContextMenu(
          store.get('language') as Language.Codes,
          store.get('preferences') as Preferences.ListType,
          newState,
          tray
        )
      );

      resolve(true);

    } catch (err) {
      console.error("Unhandled error in startDPI:", err);
      resolve(false);
    }
  });
}



async function restartDPI(tray: Tray | null | undefined): Promise<boolean> {
  return new Promise(async (resolve) => {
    if (!tray) return resolve(false);

    try {
      var stopResponse = await stopDPI(tray);
      var startResponse = await startDPI(tray);

      resolve(startResponse && stopResponse);
    } catch (err) {
      console.error("Unhandled error in restartDPI:", err);
      resolve(false);
    }
  });
}