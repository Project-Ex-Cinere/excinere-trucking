import React from "react";

export interface ThemeSwitcherProps {
  theme: string;
  toggleTheme: () => void;
}

const ThemeSwitcher: React.FC<ThemeSwitcherProps> = ({
  theme,
  toggleTheme,
}) => {
  return (
    <header className={`flex justify-between items-center p-4 ${theme === "light" ? "bg-gray-100" : "bg-gray-900"} transition-all duration-300 ease-in-out`}>
      <h1 className="font-bold text-2xl">Trucking Simulator</h1>
      <button
        className={`theme-switcher p-2 border-none cursor-pointer transition-all duration-300 ease-in-out ${
          theme === "light" ? "text-black" : "text-white"
        }`}
        onClick={toggleTheme}
        aria-label="Toggle theme"
      >
        {theme === "light" ? (
          <i className="fa-moon fas"></i>
        ) : (
          <i className="fa-sun fas"></i>
        )}
      </button>
    </header>
  );
};

export default ThemeSwitcher;