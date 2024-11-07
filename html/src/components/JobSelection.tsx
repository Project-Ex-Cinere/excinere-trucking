import React from "react";

interface JobSelectionProps {
  theme: string;
  activeJob: "quick" | "freight" | null;
  handleStartJobClick: (jobType: "quick" | "freight") => void;
}

const JobSelection: React.FC<JobSelectionProps> = ({
  theme,
  activeJob,
  handleStartJobClick,
}) => {
  const isLightTheme = theme === "light";
  const buttonBaseClasses =
    "job-button block w-full p-4 mb-2 border-none cursor-pointer text-lg transition-all duration-300 ease-in-out";
  const disabledClasses = "opacity-60 cursor-not-allowed";
  const activeClasses = "bg-green-500";

  return (
    <div
      className={`mb-8 job-selection ${isLightTheme ? "bg-white text-black" : "bg-gray-800 text-white"} p-6 rounded-lg shadow-lg`}
    >
      <h2 className="mb-4 font-bold text-2xl">Job Selection</h2>
      <button
        className={`${buttonBaseClasses} ${isLightTheme ? "bg-gray-200 text-black" : "bg-gray-700 text-white"} ${activeJob === "quick" ? activeClasses : ""} ${activeJob !== null ? disabledClasses : ""}`}
        onClick={() => handleStartJobClick("quick")}
        disabled={activeJob !== null}
        aria-pressed={activeJob === "quick"}
      >
        Quick Job
      </button>
      <button
        className={`${buttonBaseClasses} ${isLightTheme ? "bg-gray-200 text-black" : "bg-gray-700 text-white"} ${activeJob === "freight" ? activeClasses : ""} ${activeJob !== null ? disabledClasses : ""}`}
        onClick={() => handleStartJobClick("freight")}
        disabled={activeJob !== null}
        aria-pressed={activeJob === "freight"}
      >
        Freight Job
      </button>
    </div>
  );
};

export default JobSelection;
