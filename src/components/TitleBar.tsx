import React from "react";
import "../app/globals.css";

const TitleBar = () => {
    return (
      <div
      className="flex items-center justify-center mx-auto w-full text-white select-none pl-2 z-50 rounded-br-2xl rounded-bl-2xl border-b-2 border-gray-500/50 border-opacity-50 bg-zinc-700/95 shadow-2xl"
      draggable={false}
        style={{
          WebkitAppRegion: "drag",
          position: "fixed",
          top: 0,
          left: 0,
          height: "34px",
          width: "100%",  
        } as React.CSSProperties}>
        <div className="flex text-gray-100 animate-pulse hover:cursor-move tracking-wide">
            MacDPI
        </div>
      </div>
    );
  };

export default TitleBar;