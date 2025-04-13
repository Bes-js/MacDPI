import React, { useState, useEffect } from "react";
import "../../app/globals.css";
import clsx from "clsx";
import { Field, Label, Input, Description, Switch } from "@headlessui/react";
import { FaCheck, FaCloudflare, FaGoogle, FaTent } from "react-icons/fa6";


interface AdvancedOptions {
    title: string;
    description: string;
    type: 'switch' | 'input';
    id: keyof StateAdvancedOptions;
};


interface StateAdvancedOptions {
    dnsIPv4Only: boolean;
    dnsOverHttps: boolean;
    systemProxy: boolean;
    useProxy: boolean;
    timeout: string;
    clientHelloChunkSize: string;
};


/* Language Type */
import type { LanguageType } from "@/utils/language";

const Advanced = ({ language }: { language: LanguageType }) => {

    const advancedOptions: AdvancedOptions[] = [
        { title: language?.AdvancedPage.dnsipv4Only, description: language?.AdvancedPage.dnsipv4OnlyDescription, type: 'switch', id: 'dnsIPv4Only' },
        { title: language?.AdvancedPage.dnsOverHttps, description: language?.AdvancedPage.dnsOverHttpsDescription, type: 'switch', id: 'dnsOverHttps' },
        { title: language?.AdvancedPage.systemProxy, description: language?.AdvancedPage.systemProxyDescription, type: 'switch', id: 'systemProxy' },
        { title: language?.AdvancedPage.useProxy, description: language?.AdvancedPage.useProxyDescription, type: 'switch', id: 'useProxy' },
        { title: language?.AdvancedPage.timeout, description: language?.AdvancedPage.timeoutDescription, type: 'input', id: 'timeout' },
        { title: language?.AdvancedPage.clientHelloChunkSize, description: language?.AdvancedPage.clientHelloChunkSizeDescription, type: 'input', id: 'clientHelloChunkSize' },
    ];


    const [advanced, setAdvanced] = useState<StateAdvancedOptions>({
        dnsIPv4Only: false,
        dnsOverHttps: true,
        systemProxy: true,
        useProxy: false,
        timeout: '5',
        clientHelloChunkSize: '1'
    });


    useEffect(() => {

        window?.electron.ipcRenderer.on("getAdvanced", (_, data: StateAdvancedOptions) => {
            setAdvanced(data);
        });

        window?.electron.ipcRenderer.send("getAdvanced");

        return () => {
            window?.electron.ipcRenderer.removeAllListeners("getAdvanced");
        };
    }, []);




    return (
        <div className="grid grid-cols-2 pt-8 items-center justify-center gap-6 select-none">

            {advancedOptions.map((option, index) => (
                <Field key={index} className={`flex items-center justify-center text-center ${
                    (index == advancedOptions.length - 1 || index == advancedOptions.length - 2) ? 'mb-6' : ''
                }`}>
                    <div className="flex flex-col items-center justify-center gap-2">

                        <Label className="text-sm/6 font-medium text-white">{option.title}</Label>
                        <Description className="text-sm/6 text-white/50">{option.description}</Description>

                        {option.type === 'switch' ? (
                            <Switch
                                id={option.id}
                                checked={advanced[option.id] as boolean}
                                onClick={() => {
                                    setAdvanced({
                                        ...advanced,
                                        [option.id]: !advanced[option.id]
                                    });
                                    window?.electron.ipcRenderer.send("setAdvanced", {
                                        ...advanced,
                                        [option.id]: !advanced[option.id]
                                    });
                                }}
                                defaultChecked={advanced[option.id] as boolean}
                                className="group relative flex h-7 w-14 cursor-pointer rounded-full bg-white/10 p-1 transition-colors duration-200 ease-in-out focus:outline-none data-[focus]:outline-1 data-[focus]:outline-white data-[checked]:bg-white/25"
                            >
                                <span
                                    aria-hidden="true"
                                    className="pointer-events-none inline-block size-5 translate-x-0 rounded-full bg-white ring-0 shadow-lg transition duration-500 ease-in-out group-data-[checked]:translate-x-7"
                                />
                            </Switch>
                        ) : (
                            <Input
                                id={option.id}
                                value={option.id === 'timeout' ? advanced.timeout : advanced.clientHelloChunkSize}
                                defaultValue={
                                    option.id === 'timeout' ? advanced.timeout : advanced.clientHelloChunkSize}
                                onChange={(values) => {
                                    setAdvanced({
                                        ...advanced,
                                        [option.id]: values.target.value
                                    });
                                    window?.electron.ipcRenderer.send("setAdvanced", {
                                        ...advanced,
                                        [option.id]: values.target.value
                                    });
                                }}
                                type="number"
                                placeholder={option.id === 'timeout' ? '5' : '1'}
                                min={option.id === 'timeout' ? 1 : 0}
                                autoComplete="off"
                                className={clsx(
                                    'mt-1 block w-full rounded-lg border-none bg-white/5 py-1.5 px-3 text-sm/6 text-white',
                                    'focus:outline-none data-[focus]:outline-2 data-[focus]:-outline-offset-2 data-[focus]:outline-white/25 text-center disabled:opacity-50 disabled:cursor-not-allowed',
                                    'data-[disabled]:bg-white/5 data-[disabled]:text-white/50'
                                )}
                            />
                        )}
                    </div>
                </Field>
            ))}

        </div>
    );
};

export default Advanced;


