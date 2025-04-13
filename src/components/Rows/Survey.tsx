import React from "react";
import "../../app/globals.css";
import clsx from "clsx";
import { FaArrowUpRightFromSquare } from "react-icons/fa6";
import { Button } from "@headlessui/react";
import Image from "next/image";
import surveyMonkeyBanner from "@/../public/surveyMonkey.svg";

/* Language Type */
import type { LanguageType } from "@/utils/language";

const Survey = ({ language }: { language: LanguageType }) => {

    return (
        <div className="flex pt-8 items-center justify-center select-none block-scroll" draggable={false}>

            <div className="flex flex-col gap-2 items-center justify-center">
                <h1 className="text-gray-300 text-2xl font-bold mb-2">{language?.SurveyPage.survey}</h1>
                <p className="text-gray-300 text-sm mb-4">{language?.SurveyPage.surveySubtitle}</p>
                <a href="https://tr.surveymonkey.com/r/DVJ2DNX" target="_blank" rel="noopener noreferrer">
                    <Button className={`inline-flex items-center rounded-md bg-white/5 py-0.5 px-3 text-sm/6 font-semibold text-white shadow-inner shadow-white/5 focus:outline-none data-[hover]:bg-gray-600 data-[open]:bg-gray-700 data-[focus]:outline-1 data-[focus]:outline-white disabled:opacity-50 disabled:cursor-not-allowed cursor-grab transition-all duration-700 ease-in-out gap-2`}>
                        <span className="text-md text-gray-300">{language?.SurveyPage.survey}!</span>
                        <FaArrowUpRightFromSquare size={15} className={`text-gray-300`} />
                    </Button>
                </a>
                <Image className="top-0 bottom-0 flex mb-20" src={surveyMonkeyBanner} alt="Survey Banner" width={400} height={100} />
            </div>

        </div>
    );
};

export default Survey;