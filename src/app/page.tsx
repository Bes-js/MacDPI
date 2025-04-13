"use client";
import React, { useState, useEffect } from "react";
import "./globals.css";

import TitleBar from "@/components/TitleBar";
import Navbar from "@/components/Navbar";

/* Rows */
import General from "@/components/Rows/General";
import Connection from "@/components/Rows/Connection";
import DNS from "@/components/Rows/DNS";
import Advanced from "@/components/Rows/Advanced";
import Pattern from "@/components/Rows/Pattern";
import Survey from "@/components/Rows/Survey";

/* Language */
import languageList, { LanguageList } from "@/utils/language";

/* General Types */
interface Informations {
  connection: boolean;
  isp: string;
  colocationCenter: string;
  connectionType: string;
  publicIP: string;
  deviceInformation: string;
};

export default function Home() {

  const [selected, setSelected] = useState<string>('General');

  const [language, setLanguage] = useState<LanguageList>("en");

  useEffect(() => {

    window?.electron.ipcRenderer.on("getLanguage", (_, lang: LanguageList) => {
      setLanguage(lang);
    });

    window?.electron.ipcRenderer.send("getLanguage");

  }, []);


  /* General */
  const [information, setInformation] = useState<Informations>({
    connection: false,
    isp: "...",
    colocationCenter: "...",
    connectionType: "...",
    publicIP: "127.0.0.1",
    deviceInformation: "...",
  });


  useEffect(() => {

    window?.electron.ipcRenderer.send("getInformations");

    window?.electron.ipcRenderer.on("getInformations", (_, data: Informations) => {
      setInformation(data);
    });

  }, []);


  return (
    <div className="w-full h-screen relative">

      <TitleBar />


      <Navbar navbarCategories={[
        { title: languageList[language].Titles.General, key: "General" },
        { title: languageList[language].Titles.Connection, key: "Connection" },
        { title: languageList[language].Titles.DNS, key: "DNS" },
        { title: languageList[language].Titles.Pattern, key: "Pattern" },
        { title: languageList[language].Titles.Advanced, key: "Advanced" },
        { title: languageList[language].Titles.Survey, key: "Survey" }
      ]} state={{
        value: selected,
        setValue: setSelected
      }} />

      {
        [
          {
            key: "General",
            component: <General language={languageList[language]} information={information} />
          },
          {
            key: "Connection",
            component: <Connection language={languageList[language]} />
          },
          {
            key: "DNS",
            component: <DNS language={languageList[language]} />
          },
          {
            key: "Pattern",
            component: <Pattern language={languageList[language]} />
          },
          {
            key: "Advanced",
            component: <Advanced language={languageList[language]} />
          },
          {
            key: "Survey",
            component: <Survey language={languageList[language]} />
          }
        ].filter((item) => item.key === selected).map((item) => (
          <div className="w-full" key={item.key}>
            {item.component}
          </div>
        ))
      }

    </div>
  );
}
