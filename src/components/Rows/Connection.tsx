import React, { useState, useEffect } from "react";
import "../../app/globals.css";
import clsx from "clsx";
import { Field, Label, Input, Description, Button, Checkbox } from "@headlessui/react";
import { FaCheck } from "react-icons/fa6";

/* Language Type */
import type { LanguageType } from "@/utils/language";

const Connection = ({ language }: { language: LanguageType }) => {

    const [isChanged, setIsChanged] = useState<boolean>(false);
    const [isSaved, setIsSaved] = useState<boolean>(false);

    const [address, setAddress] = useState<string>("127.0.0.1");
    const [port, setPort] = useState<number>(8080);

    const [useDefaultAddress, setUseDefaultAddress] = useState<boolean>(true);
    const [useDefaultPort, setUseDefaultPort] = useState<boolean>(true);


    useEffect(() => {
        window?.electron.ipcRenderer.on("getProxy", (_, data: { address: string, port: number, useDefaultAddress: boolean; useDefaultPort: boolean; }) => {
            setAddress(data.address);
            setPort(data.port);
            setUseDefaultAddress(data.useDefaultAddress);
            setUseDefaultPort(data.useDefaultPort);

            if (data.useDefaultAddress) setAddress("127.0.0.1");
            if (data.useDefaultPort) setPort(8080);
            
        });

        window?.electron.ipcRenderer.send("getProxy");

        return () => {
            window?.electron.ipcRenderer.removeAllListeners("getProxy");
        };
    }, []);

    const handleSaveChanges = () => {
        setIsSaved(true);
        setIsChanged(false);
        setTimeout(() => { setIsSaved(false); }, 3000);

        window?.electron.ipcRenderer.send("setProxy", {
            address,
            port,
            useDefaultAddress,
            useDefaultPort
        });

    };



    return (
        <div className="flex pt-8 items-center justify-center flex-col gap-4 select-none">

            <Field className={clsx(
                'flex flex-col items-center justify-center text-center'
            )}>
                <Label className="text-sm/6 font-medium text-white">{language?.ConnectionPage.address}</Label>
                <Description className="text-sm/6 text-white/50">{language?.ConnectionPage.adressDescription}</Description>

                <div className="flex items-center justify-center gap-2">
                <Checkbox
                    checked={useDefaultAddress}
                    disabled={isSaved}
                    onChange={() => {
                        setIsChanged(true);
                        setUseDefaultAddress(!useDefaultAddress); 
                        if (!useDefaultAddress == true) setAddress("127.0.0.1");
                    }}
                    className={`group size-4 rounded-md bg-white/10 ring-1 ring-white/15 ring-inset data-[checked]:bg-white flex items-center justify-center ${isSaved ? 'cursor-not-allowed' : 'cursor-pointer'}`}>
                    <FaCheck className="hidden size-3 fill-gray-700 group-data-[checked]:block" />
                </Checkbox>

                <Description className="text-sm/6 text-white/35">{language?.useDefault} (127.0.0.1)</Description>
                </div>

                <Input
                    disabled={useDefaultAddress || isSaved}
                    value={address}
                    onChange={(e) => {
                         setIsChanged(true);
                         setAddress(e.target.value);
                    }}
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
                        'mt-1 block w-full rounded-lg border-none bg-white/5 py-1.5 px-3 text-sm/6 text-white',
                        'focus:outline-none data-[focus]:outline-2 data-[focus]:-outline-offset-2 data-[focus]:outline-white/25 text-center disabled:opacity-50 disabled:cursor-not-allowed',
                        'data-[disabled]:bg-white/5 data-[disabled]:text-white/50'
                    )}
                />
            </Field>

            <Field className={clsx(
                'flex flex-col items-center justify-center text-center'
            )}>
                <Label className="text-sm/6 font-medium text-white">{language?.ConnectionPage.port}</Label>
                <Description className="text-sm/6 text-white/50">{language?.ConnectionPage.portDescription}</Description>

                <div className="flex items-center justify-center gap-2">
                <Checkbox
                    checked={useDefaultPort}
                    disabled={isSaved}
                    onChange={() => { 
                        setIsChanged(true);
                        setUseDefaultPort(!useDefaultPort);
                        if (!useDefaultPort == true) setPort(8080);
                    }}
                    className={`group size-4 rounded-md bg-white/10 ring-1 ring-white/15 ring-inset data-[checked]:bg-white flex items-center justify-center ${isSaved ? 'cursor-not-allowed' : 'cursor-pointer'}`}>
                    <FaCheck className="hidden size-3 fill-gray-700 group-data-[checked]:block" />
                </Checkbox>

                <Description className="text-sm/6 text-white/35">{language?.useDefault} (8080)</Description>
                </div>

                <Input
                    disabled={useDefaultPort || isSaved}
                    value={port}
                    onChange={(e) => {
                        setIsChanged(true);
                        setPort(Number(e.target.value));
                    }}
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
            </Field>


            <Button className={`inline-flex items-center rounded-md ${isSaved ? 'bg-green-500/50' : 'bg-white/5'} py-0.5 px-3 text-sm/6 font-semibold text-white shadow-inner shadow-white/5 focus:outline-none data-[hover]:bg-gray-600 data-[open]:bg-gray-700 data-[focus]:outline-1 data-[focus]:outline-white disabled:opacity-50 disabled:cursor-not-allowed cursor-grab transition-all duration-700 ease-in-out`}
                disabled={isChanged == false}
                onClick={handleSaveChanges}
            >
                <FaCheck size={20} className={`fill-white ${isSaved ? 'block px-1' : 'hidden'}`} />
                <span>{isSaved ? language?.saved : language?.saveChanges}</span>
            </Button>


        </div>
    );
};

export default Connection;


