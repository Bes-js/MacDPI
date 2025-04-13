"use client";
import React from "react";
import "../app/globals.css";


namespace NavbarNamescape {

    export type NavbarCategories = string[];

    export interface NavbarOptions { 
        navbarCategories: { title: string; key: string; }[];
        state:  State
    };

    export interface State {
        value: string;
        setValue: React.Dispatch<React.SetStateAction<string>>;
    };

};

const Navbar = ({ navbarCategories, state }: NavbarNamescape.NavbarOptions) => {


    return (
      <div className="flex items-center justify-center mx-auto w-full text-white select-none pt-12" draggable={false}>

        <div className="flex flex-nowrap grid-cols-3 gap-2">
            {
                navbarCategories.map((item, index) => (
                    <div key={index} className={`flex flex-col items-center justify-center border-2 rounded-lg pr-1 pl-1 text-nowrap cursor-pointer  border-gray-500 hover:bg-gray-600 transition-all duration-300 hover:scale-105 ${
                        state.value == item.key ?
                        "bg-gray-500 bg-opacity-50 border-gray-400 animate-pulse" :
                        ""
                    }`}
                    onClick={() => state.setValue(item.key)}
                    >
                        <span className="text-gray-300 text-sm">{item.title}</span>
                    </div>
                ))
            }
        </div>

      </div>
    );
  };

export default Navbar;