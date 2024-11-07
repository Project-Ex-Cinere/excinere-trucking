import React from "react";

interface JobDetailsProps {
  theme: string;
  activeJob: "quick" | "freight" | null;
  jobTypes: {
    quick: {
      title: string;
      description: string;
      reward: number;
      distance: number;
    };
    freight: {
      title: string;
      description: string;
      reward: number;
      distance: number;
    };
  };
}

const JobDetails: React.FC<JobDetailsProps> = ({
  theme,
  activeJob,
  jobTypes,
}) => {
  if (!activeJob) {
    return (
      <div
        className={`no-job p-6 rounded-lg shadow-lg ${theme === "light" ? "bg-white text-black" : "bg-gray-800 text-white"}`}
      >
        <h2 className="mb-4 font-bold text-2xl">No Active Job</h2>
        <p>Please select a job to view details.</p>
      </div>
    );
  }

  return (
    <div
      className={`job-details p-6 rounded-lg shadow-lg ${theme === "light" ? "bg-white text-black" : "bg-gray-800 text-white"}`}
    >
      <h2 className="mb-4 font-bold text-2xl">Current Job Details</h2>
      <p className="mb-2">
        <strong>Title:</strong> {jobTypes[activeJob].title}
      </p>
      <p className="mb-2">
        <strong>Description:</strong> {jobTypes[activeJob].description}
      </p>
      <p className="mb-2">
        <strong>Reward:</strong> ${jobTypes[activeJob].reward}
      </p>
      <p className="mb-2">
        <strong>Distance:</strong> {jobTypes[activeJob].distance} km
      </p>
    </div>
  );
};

export default JobDetails;
