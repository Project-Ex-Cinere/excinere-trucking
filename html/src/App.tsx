import { useState, useEffect } from "react";
import DriverInfo from "./components/DriverInfo";
import JobSelection from "./components/JobSelection";
import JobDetails from "./components/JobDetails";
import ConfirmationModal from "./components/ConfirmationModal";
import ThemeSwitcher from "./components/ThemeSwitcher";
import { DriverStats } from "./components/DriverInfo";

export default function TruckingSimulatorUI() {
  // Uncomment these to use yarn dev:
  // const [theme, setTheme] = useState("dark");
  // const [activeJob, setActiveJob] = useState<"quick" | "freight" | null>(
  //   "quick",
  // );
  // const [driverStats, setDriverStats] = useState<DriverStats | null>({
  //   name: "John Doe",
  //   level: 1,
  //   experience: 0,
  // });
  // const [jobTypes, setJobTypes] = useState({
  //   quick: {
  //     title: "",
  //     description: "",
  //     reward: 0,
  //     distance: 0,
  //   },
  //   freight: {
  //     title: "",
  //     description: "",
  //     reward: 0,
  //     distance: 0,
  //   },
  // });
  // const [showStartJobConfirm, setShowStartJobConfirm] = useState(false);
  // const [showCancelJobConfirm, setShowCancelJobConfirm] = useState(false);
  // const [pendingJobType, setPendingJobType] = useState<
  //   "quick" | "freight" | null
  // >("quick");

  // and comment these:
  const [theme, setTheme] = useState("dark");
  const [activeJob, setActiveJob] = useState<"quick" | "freight" | null>(null);
  const [driverStats, setDriverStats] = useState<DriverStats | null>(null);
  const [jobTypes, setJobTypes] = useState({
    quick: {
      title: "",
      description: "",
      reward: 0,
      distance: 0,
    },
    freight: {
      title: "",
      description: "",
      reward: 0,
      distance: 0,
    },
  });
  const [showStartJobConfirm, setShowStartJobConfirm] = useState(false);
  const [showCancelJobConfirm, setShowCancelJobConfirm] = useState(false);
  const [pendingJobType, setPendingJobType] = useState<
    "quick" | "freight" | null
  >(null);

  useEffect(() => {
    document.getElementById("main_container")?.classList.add("hidden");
    window.addEventListener("message", (event) => {
      const data = event.data;

      switch (data.type) {
        case "open":
          console.log(JSON.stringify(data));
          setDriverStats(data.driverStats);
          setJobTypes(data.jobTypes);
          setActiveJob(data.activeJob);
          openTruckingSimulator();
          break;
        case "showStartJobConfirm":
          setPendingJobType(data.jobType);
          setShowStartJobConfirm(true);
          break;
        case "hideStartJobConfirm":
          setShowStartJobConfirm(false);
          break;
        case "updateActiveJob":
          setActiveJob(data.jobType);
          break;
        case "showCancelJobConfirm":
          setShowCancelJobConfirm(true);
          break;
        case "hideCancelJobConfirm":
          setShowCancelJobConfirm(false);
          break;
      }
    });
  }, []);

  const handleStartJobClick = (jobType: "quick" | "freight") => {
    fetch(`https://${GetParentResourceName()}/startJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ jobType }),
    });
  };

  const confirmStartJob = () => {
    fetch(`https://${GetParentResourceName()}/confirmStartJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    });
  };

  const cancelStartJob = () => {
    fetch(`https://${GetParentResourceName()}/cancelStartJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    });
  };

  const handleCancelJobClick = () => {
    fetch(`https://${GetParentResourceName()}/cancelJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    });
  };

  const confirmCancelJob = () => {
    fetch(`https://${GetParentResourceName()}/confirmCancelJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    });
  };

  const cancelCancelJob = () => {
    fetch(`https://${GetParentResourceName()}/cancelCancelJob`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
    });
  };

  const openTruckingSimulator = () => {
    document.getElementById("main_container")?.classList.remove("hidden");
  };

  const toggleTheme = () => {
    setTheme((prevTheme) => (prevTheme === "light" ? "dark" : "light"));
  };

  return (
    <div
      id="main_container"
      className={`${theme} font-sans p-5 relative ${
        theme === "light" ? "bg-gray-100 text-black" : "bg-gray-900 text-white"
      } h-[80vh] w-[90vw] mx-auto rounded-xl transition-all duration-300 ease-in-out`}
    >
      <ThemeSwitcher theme={theme} toggleTheme={toggleTheme} />
      <div className="flex h-[calc(100%-50px)] main-content">
        <div className="left-side p-5 w-1/2">
          <div className="mb-8">
            <DriverInfo theme={theme} driverStats={driverStats} />
          </div>
          <div className="mb-8">
            <JobSelection
              theme={theme}
              activeJob={activeJob}
              handleStartJobClick={handleStartJobClick}
            />
          </div>
          {activeJob && (
            <div className="mb-8 job-interaction">
              <button
                className={`p-4 border-none text-lg cursor-pointer cancel-button ${
                  theme === "light"
                    ? "bg-red-500 text-white"
                    : "bg-red-900 text-white"
                } transition-all duration-300 ease-in-out`}
                onClick={handleCancelJobClick}
              >
                Cancel Current Job
              </button>
            </div>
          )}
        </div>
        <div
          className="right-side p-5 w-1/2"
        >
          <JobDetails theme={theme} activeJob={activeJob} jobTypes={jobTypes} />
        </div>
      </div>
      <ConfirmationModal
        theme={theme}
        show={showStartJobConfirm}
        message={`Are you sure you want to start ${
          pendingJobType === "quick" ? "Quick Job" : "Freight Job"
        }?`}
        onConfirm={confirmStartJob}
        onCancel={cancelStartJob}
      />
      <ConfirmationModal
        theme={theme}
        show={showCancelJobConfirm}
        message="Are you sure you want to cancel the current job?"
        onConfirm={confirmCancelJob}
        onCancel={cancelCancelJob}
      />
    </div>
  );
}
