import React, { useState, useEffect } from "react";
import "../../app/globals.css";
import Image from "next/image";
import clsx from "clsx";
import { Field, Label, Input, Description, Button, RadioGroup, Radio } from "@headlessui/react";
import { FaGoogle, FaCloudflare, FaTent, FaCheck, FaStar, FaYandex, FaShield, FaCloud, Fa9 } from "react-icons/fa6";
import { FiArrowDownCircle } from "react-icons/fi";
import Mullvad from "@/../public/mulvad.svg";
import OpenDNS from "@/../public/opendns.svg";

interface Pattern {
    title: string;
    description: string;
    icon?: React.ReactNode;
    id: 'google' | 'cloudflare' | 'custom' | 'quad9' | 'nextdns' | 'yandex' | 'adguard' | 'mullvad' | 'opendns';
};

type Services = keyof typeof services;

const services = {
    'google': 0,
    'cloudflare': 1,
    'custom': 2,
};



/* Language Type */
import type { LanguageType } from "@/utils/language";

const DNS = ({ language }: { language: LanguageType }) => {

    const patterns: Pattern[] = [
        { title: language?.DNSPage.useGoogle, description: "(8.8.8.8)", icon: <FaGoogle size={20} className="text-white flex items-center justify-center" />, id: "google" },
        { title: language?.DNSPage.useCloudflare, description: "(1.1.1.1)", icon: <FaCloudflare size={25} className="text-white flex items-center justify-center" />, id: "cloudflare" },

        { title: language?.DNSPage.useQuad9, description: "(9.9.9.9)", icon: <Fa9 size={20} className="text-white flex items-center justify-center" />, id: "quad9" },
        { title: language?.DNSPage.useNextDNS, description: "(45.90.28.0)", icon: <FaShield size={20} className="text-white flex items-center justify-center" />, id: "nextdns" },
        { title: language?.DNSPage.useYandex, description: "(77.88.8.8)", icon: <FaYandex size={20} className="text-white flex items-center justify-center" />, id: "yandex" },
        { title: language?.DNSPage.useAdGuard, description: "(94.140.14.14)", icon: <FaCloud size={20} className="text-white flex items-center justify-center" />, id: "adguard" },
        { title : language?.DNSPage.useMullvad, description: '(100.64.0.1)', icon: <Image alt="Mullvad" width={30} height={30} src={Mullvad} className="text-white flex items-center justify-center select-none" draggable={false} />, id: "mullvad" },
        { title: language?.DNSPage.useOpenDNS, description: '(208.67.222.222)', icon: <Image alt="OpenDNS" width={30} height={30} src={OpenDNS} className="text-white flex items-center justify-center select-none" draggable={false} />, id: "opendns" },
        { title: language?.DNSPage.useCustom, description: language?.DNSPage.customAddress, icon: <FaTent size={20} className="text-white flex items-center justify-center" />, id: "custom" },
    ];


    const [selected, setSelected] = useState<Pattern>(patterns[0]);
    const [isChanged, setIsChanged] = useState<boolean>(false);
    const [isSaved, setIsSaved] = useState<boolean>(false);

    const [address, setAddress] = useState<string>("127.0.0.1");
    const [port, setPort] = useState<number>(8080);

    /* Scroll */
    const [scrollTop, setScrollTop] = useState(0);

    useEffect(() => {
        window.onscroll = () => {
            setScrollTop(window.scrollY);
        };
    }, []);


    useEffect(() => {
        window?.electron.ipcRenderer.on("getDNS", (_, data: { service: Services; address: string, port: number }) => {
            
            setSelected(patterns[services[data.service]] || patterns[0]);
            setAddress(data.address);
            setPort(data.port);
            setIsChanged(false);
        });

        window?.electron.ipcRenderer.send("getDNS");

        return () => {
            window?.electron.ipcRenderer.removeAllListeners("getDNS");
        };
    }, []);



    const handleSaveChanges = () => {
        setIsSaved(true);
        setIsChanged(false);
        setTimeout(() => { setIsSaved(false); }, 3000);

        window?.electron.ipcRenderer.send("setDNS", {
            service: selected.title.split(" ")[1]?.toLowerCase(),
            address,
            port,
        });
    };



    return (
        <div className="flex pt-8 items-center justify-center flex-col gap-4 select-none scroolbar-hide">

            <Field className={clsx(
                'flex flex-col items-center justify-center text-center'
            )}>
                <Label className="text-sm/6 font-medium text-white">{language?.DNSPage.dns}</Label>
                <Description className="text-sm/6 text-white/50">{language?.DNSPage.dnsDescription}</Description>

                <div className="flex items-center justify-center gap-2 mt-4">
                    <RadioGroup value={selected} onChange={(pattern) => {
                        setSelected(pattern);
                        setIsChanged(true);
                        setAddress(pattern.id === "custom" ? address : pattern.description.replace(/[^0-9.]/g, ""));
                        setPort(
                            pattern.id === "custom" ? port : 53);

                           if (pattern.id === "custom") {
                            setTimeout(() => {
                                window.scrollTo({
                                  top: 9999,
                                  behavior: "smooth"
                              });
                              setScrollTop(9999);
                            }, 1000);
                              
                           }; 

                    }} aria-label="Server size" className="grid grid-cols-3 gap-6">
                        {patterns.map((plan,i) => (

                            <Radio
                                key={plan.title}
                                value={plan}
                                disabled={isSaved}
                                className={`group relative flex ${isSaved ? 'cursor-not-allowed' : 'cursor-pointer'} disabled:cursor-not-allowed rounded-lg bg-white/5 py-2 text-white shadow-md transition focus:outline-none data-[focus]:outline-1 data-[focus]:outline-white data-[checked]:bg-white/10 data-[checked]:border-[1px] data-[checked]:animate-pulse duration-700 ease-in-out items-center justify-center text-center] ${
                                    (i === (patterns.length - 1 || patterns.length - 2)) ? 'col-span-1' : ''
                                }`}
                            >
                                {
                                    (plan.id === "google") && (
                                        <div className="absolute top-0.5 left-1 p-1 text-xs font-semibold text-gray-800 animate-pulse">
                                            <FaStar size={18} className="text-white flex items-center justify-center" />
                                        </div>
                                    )
                                }

                                <div className="flex items-center justify-center gap-2 px-2">
                                    <div className="text-sm/6 items-center justify-center flex flex-col">
                                        {plan.icon}
                                        <p className="font-semibold text-white">{plan.title}</p>
                                        <div className="flex gap-2 text-white/50 items-center justify-center">
                                            <span>{plan.description}</span>
                                        </div>
                                    </div>
                                </div>
                            </Radio>
                        ))}
                    </RadioGroup>
                </div>

            </Field>


            <Field className={clsx(
                'flex flex-col items-center justify-center text-center mt-4',
                selected.id == "custom" ? "block" : "hidden"
            )}>

                <Label className="text-sm/6 font-medium text-white">{language?.DNSPage.customAddress}</Label>
                <Description className="text-sm/6 text-white/50">{language?.DNSPage.customAddressDescription}</Description>

                <Input
                    disabled={isSaved}
                    value={address}
                    onChange={(e) => setAddress(e.target.value)}
                    type="text"
                    placeholder="127.0.0.1"
                    autoComplete="off"
                    autoCorrect="off"
                    autoCapitalize="none"
                    spellCheck="false"
                    inputMode="text"
                    pattern="[0-9]*"
                    autoFocus={false}
                    maxLength={15}
                    minLength={7}
                    onKeyDown={(e) => {
                        if (e.key === "Enter") {
                            e.preventDefault();
                            setAddress(e.currentTarget.value);
                        }
                    }}
                    className={clsx(
                        'mt-4 block w-full rounded-lg border-none bg-white/5 py-1.5 px-3 text-sm/6 text-white',
                        'focus:outline-none data-[focus]:outline-2 data-[focus]:-outline-offset-2 data-[focus]:outline-white/25 text-center disabled:opacity-50 disabled:cursor-not-allowed',
                        'data-[disabled]:bg-white/5 data-[disabled]:text-white/50',
                        selected.id == "custom" ? "block" : "hidden"
                    )}
                />

                <div className="flex items-center justify-center gap-4 mt-2">

                    <Label className="text-sm/6 font-medium text-white text-nowrap">{language?.DNSPage.customPort}</Label>

                    <Input
                        disabled={isSaved}
                        value={port}
                        onChange={(e) => setPort(Number(e.target.value))}
                        type="number"
                        min={0}
                        max={65535}
                        step={1}
                        placeholder="8080"
                        autoComplete="off"
                        autoCorrect="off"
                        autoCapitalize="none"
                        spellCheck="false"
                        inputMode="numeric"
                        pattern="[0-9]*"
                        autoFocus={false}
                        className={clsx(
                            'mt-1 block w-full rounded-lg border-none bg-white/5 py-1.5 px-3 text-sm/6 text-white',
                            'focus:outline-none data-[focus]:outline-2 data-[focus]:-outline-offset-2 data-[focus]:outline-white/25 text-center disabled:opacity-50 disabled:cursor-not-allowed',
                            'data-[disabled]:bg-white/5 data-[disabled]:text-white/50'
                        )}
                    />

                </div>

            </Field>


            {
                (selected.id == "custom" && scrollTop !== 9999 && scrollTop >= 200) && (
                    <div className="fixed right-8 gap-2 bottom-6 cursor-pointer"
                        onClick={(e) => {
                            window.scrollTo({
                                top: 0,
                                behavior: "smooth"
                            });
                            setScrollTop(0);
                        }}
                    >
                        <FiArrowDownCircle size={40} className={`text-gray-300 flex items-center justify-center animate-pulse transition-all ease-in-out duration-1000 rotate-180`} />
                    </div>
                )
            }


            <Button className={`inline-flex items-center rounded-md ${isSaved ? 'bg-green-500/50' : 'bg-white/5'} py-0.5 px-3 text-sm/6 font-semibold text-white shadow-inner shadow-white/5 focus:outline-none data-[hover]:bg-gray-600 data-[open]:bg-gray-700 data-[focus]:outline-1 data-[focus]:outline-white disabled:opacity-50 disabled:cursor-not-allowed cursor-grab transition-all duration-700 ease-in-out mb-4`}
                disabled={isChanged == false}
                onClick={handleSaveChanges}
            >
                <FaCheck size={20} className={`fill-white ${isSaved ? 'block px-1' : 'hidden'}`} />
                <span>{isSaved ? language?.saved : language?.saveChanges}</span>
            </Button>


        </div>
    );
};

export default DNS;


