import React, { useEffect, useState } from "react";
import "../../app/globals.css";
import { FaDiscord, FaGithub, FaInstagram, FaMugHot } from "react-icons/fa6";

/* Language Type */
import type { LanguageType } from "@/utils/language";

interface Informations {
    connection: boolean;
    isp: string;
    colocationCenter: string;
    connectionType: string;
    publicIP: string;
    deviceInformation: string;
};

const General = ({ language, information }: { language: LanguageType, information: Informations }) => {

    const [showIP, setShowIP] = useState<boolean>(false);

    return (
        <div className="flex pt-8 items-center justify-center">

            <div className="flex flex-col items-center justify-center text-white select-none">

            <h3 className="text-gray-200 text-lg underline underline-offset-2">{language?.Connection.connectionInformation}</h3>

            <ul className="text-sm items-center justify-center flex flex-col gap-2">

                <li className="text-gray-400">
                <strong className="text-gray-200">{language?.Connection.connection}:</strong> {information.connection ? language?.on : language?.off}
                    </li>

                <li className="text-gray-400">
                <strong className="text-gray-200">{language?.Connection.isp}:</strong> {information.isp}
                    </li>

                <li className="text-gray-400">
                <strong className="text-gray-200">{language?.Connection.colocationCenter}:</strong> {information.colocationCenter}
                    </li>

            </ul>


            <h3 className="text-gray-200 text-lg mt-6 underline underline-offset-2">{language?.Connection.yourDevice}</h3>
            <ul className="text-sm items-center justify-center flex flex-col gap-2">

                <li className="text-gray-400">
                <strong className="text-gray-200">{language?.Connection.connectionType}:</strong> {
                    information.connectionType == "" ? "Wi-Fi" : information.connectionType
                }
                    </li>

                <li className="text-gray-400 hover:cursor-pointer" onClick={() => setShowIP(!showIP)}>
                <strong className="text-gray-200">{language?.Connection.publicIP}:</strong> {showIP ? information.publicIP : information.publicIP.replace(/\d/g, "*") }
                    </li>

                <li className="text-gray-400">
                <strong className="text-gray-200">{language?.Connection.deviceInformation}:</strong> {information.deviceInformation}
                    </li>
            </ul>


            <div className="flex items-center justify-center mt-6 text-nowrap gap-4">
                <a href="https://discord.gg/luppux" target="_blank" rel="noopener noreferrer">
                  <FaDiscord className="text-gray-400 hover:text-blue-600 transition duration-700 ease-in-out hover:scale-110" size={30} />
               </a>

               <a href="https://instagram.com/_berknt" target="_blank" rel="noopener noreferrer">
                  <FaInstagram className="text-gray-400 hover:text-fuchsia-600 transition duration-700 ease-in-out hover:scale-110" size={30} />
               </a>  

               <a href="https://github.com/Bes-js" target="_blank" rel="noopener noreferrer">
                  <FaGithub className="text-gray-400 hover:text-black transition duration-700 ease-in-out hover:scale-110" size={30} />
               </a>  

               <a href="https://buymeacoffee.com/beykant" target="_blank" rel="noopener noreferrer">
                  <FaMugHot className="text-gray-400 hover:text-yellow-500 transition duration-700 ease-in-out hover:scale-110" size={30} />
               </a> 
            </div>
               


            </div>

        </div>
    );
};

export default General;