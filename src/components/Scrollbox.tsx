import React from 'react';
import "../app/globals.css";

const ScrollBox = ({ children }: { children: React.ReactNode }) => {
  return (
    <div className="scroll-box">
      {children}
    </div>
  );
};

export default ScrollBox;