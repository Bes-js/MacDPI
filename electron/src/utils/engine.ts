import { spawn, ChildProcessWithoutNullStreams } from "child_process";
import { store } from "../main";

export namespace DPI {
    export interface Proxy {
        address: string;
        port: number;
        useDefaultAddress: boolean;
        useDefaultPort: boolean;
    };

    export interface DNS {
        service: string;
        address: string;
        port: number;
    };

    export interface Advanced {
        dnsIPv4Only: boolean;
        dnsOverHttps: boolean;
        systemProxy: boolean;
        useProxy: boolean;
        timeout: string;
        clientHelloChunkSize: string;
    };

    export interface Pattern {
        id: number;
        domain: string;
    };

    export interface Options {
        proxy: Proxy;
        DNS: DNS;
        advanced: Advanced;
        pattern: Pattern[];
    };

    export type Services = {
        proxy: Proxy;
        dns: DNS;
        advanced: Advanced;
        pattern: Pattern[];
    };
};



export class DPIEngine {
    public defaultProxy = {
        address: "127.0.0.1",
        port: 8080,
        useDefaultAddress: true,
        useDefaultPort: true
    };
    public defaultDNS = {
        service: 'google',
        address: '8.8.8.8',
        port: 53,
    };
    public defaultAdvanced = {
        dnsIPv4Only: false,
        dnsOverHttps: true,
        systemProxy: true,
        useProxy: false,
        timeout: '5',
        clientHelloChunkSize: '1'
    };
    public defaultPattern = [];

    public spawner: ChildProcessWithoutNullStreams | null = null;




    getOptions(): DPI.Services {
        const proxy: DPI.Proxy = { ...this.defaultProxy, ...(store.get("proxy") || {}) };
        const DNS: DPI.DNS = { ...this.defaultDNS, ...(store.get("DNS") || {}) };
        const advanced: DPI.Advanced = { ...this.defaultAdvanced, ...(store.get("advanced") || {}) };
        const pattern = store.get("pattern") as any[] || this.defaultPattern;

        return {
            proxy: proxy,
            dns: DNS,
            advanced: advanced,
            pattern: pattern
        }
    };


    async startDPI(): Promise<boolean> {
        return new Promise((resolve) => {
            const customPath = `${process.env.HOME}/.spoofdpi/bin:${process.env.PATH}`;
            console.log("[DPIEngine][startDPI] Custom PATH:", customPath);

            const options = this.getOptions();
            console.log("[DPIEngine][startDPI] Options:", options);

            const escapeRegex = (str: string): string => {
                return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            };

            const patternsToRegex = Array.isArray(options.pattern)
                ? options.pattern
                    .filter((pattern) => typeof pattern?.domain === "string")
                    .map((pattern) => escapeRegex(pattern.domain))
                    .join("|")
                : "";
            console.log("[DPIEngine][startDPI] Patterns to regex:", patternsToRegex);


            const timeout = Number(options.advanced.timeout) * 1000;


            const which = spawn("which", ["spoofdpi"], {
                env: {
                    ...process.env,
                    PATH: customPath,
                },
            });

            let output = "";


            which.stdout.on("data", (data) => {
                output += data.toString();
            });

            which.stderr.on("data", (data) => {
                console.error("stderr (which):", data.toString());
                resolve(false);
            });

            which.on("close", (code) => {
                console.log(output);

                if (output.includes("spoofdpi")) {
                    console.log("SpoofDPI bulundu:", output.trim());

                    const args = [
                        "--addr", options.proxy.useDefaultAddress ? '127.0.0.1' : options.proxy.address,
                        "--port", options.proxy.useDefaultPort ? String(8080) : options.proxy.port.toString(),

                        "--dns-addr", options.dns.address,
                        "--dns-port", String(options.dns.port),


                        "--window-size", options.advanced.clientHelloChunkSize,
                        "--pattern", `.*(?:${patternsToRegex}).*`,
                        "--timeout", timeout.toString(),
                    ];

                    if (options.pattern.length > 0) {
                        args.push("--pattern", patternsToRegex);
                    };

                    if (options.advanced.dnsIPv4Only) {
                        args.push("--dns-ipv4-only");
                    };

                    if (options.advanced.dnsOverHttps) {
                        args.push("--enable-doh");
                    };

                    if (options.advanced.systemProxy) {
                        args.push("--system-proxy");
                    };


                    const run = spawn("spoofdpi", args, {
                        env: {
                            ...process.env,
                            PATH: customPath,
                        },
                    });

                    this.spawner = run;

                    run.stdout.on("data", (data) => {
                        console.log("[spoofdpi]", data.toString());
                        if (data.toString().includes("ADDR")) {
                            console.log("[DPIEngine][startDPI] SpoofDPI started.");
                            resolve(true);
                        }
                    });

                    run.stderr.on("data", (data) => {
                        console.error("[spoofdpi][error]", data.toString());
                    });

                    run.on("close", (code) => {
                        if (code === 0) {
                            resolve(true);
                        } else {
                            console.error("SpoofDPI çalışma hatası. Çıkış kodu:", code);
                            resolve(false);
                        }
                    });

                    run.on("error", (err) => {
                        console.error("SpoofDPI çalıştırılamadı:", err);
                        resolve(false);
                    });
                } else {
                    console.error("SpoofDPI bulunamadı.");
                    resolve(false);
                }
            });
        });
    };


    async stopDPI(): Promise<boolean> {
        return new Promise((resolve) => {
            if (this.spawner) {
                this.spawner.kill();
                this.spawner = null;
                console.log("[DPIEngine][stopDPI] SpoofDPI stopped.");
                resolve(true);
            } else {
                console.log("[DPIEngine][stopDPI] SpoofDPI is not running.");
                resolve(false);
            }
        });
    };


    async restartDPI(): Promise<boolean> {
        return new Promise(async (resolve) => {
            await Promise.all([
                this.stopDPI(),
                this.startDPI()
            ]).catch((err) => {
                console.error("[DPIEngine][restartDPI] Error:", err);
                resolve(false);
            });
            resolve(true);
        });
    };

};





export async function checkSpoofDPIInstalled(): Promise<boolean> {
    return new Promise((resolve) => {
        const customPath = `${process.env.HOME}/.spoofdpi/bin:${process.env.PATH}`;
        const which = spawn("which", ["spoofdpi"], {
            env: {
                ...process.env,
                PATH: customPath,
            },
        });

        let output = "";

        which.stdout.on("data", (data) => {
            output += data.toString();
        });

        which.stderr.on("data", (data) => {
            console.error("stderr:", data.toString());
        });

        which.on("close", (code) => {
            if (output.includes("spoofdpi")) {
                console.log("SpoofDPI bulundu:", output.trim());
                resolve(true);
            } else {
                console.log("SpoofDPI bulunamadı.");
                resolve(false);
            }
        });
    });
};






export async function installSpoofDPI(): Promise<boolean> {
    return new Promise((resolve) => {
        const arch = process.arch;
        const archArg = arch === "arm64" ? "darwin-arm64" : "darwin-amd64";

        const curl = spawn("curl", [
            "-fsSL",
            "https://raw.githubusercontent.com/xvzc/SpoofDPI/main/install.sh",
        ]);

        const bash = spawn("bash", ["-s", archArg]);

        curl.stdout.pipe(bash.stdin);

        bash.stdout.on("data", (data) => {
            console.log("[spoofdpi-install]", data.toString());
        });

        bash.stderr.on("data", (data) => {
            console.error("[spoofdpi-install][error]", data.toString());
        });

        bash.on("close", (code) => {
            if (code === 0) {
                console.log("SpoofDPI başarıyla yüklendi.");
                resolve(true);
            } else {
                console.error("SpoofDPI kurulumu başarısız oldu. Kod:", code);
                resolve(false);
            }
        });

        bash.on("error", (err) => {
            console.error("Bash process error:", err);
            resolve(false);
        });
    });
};