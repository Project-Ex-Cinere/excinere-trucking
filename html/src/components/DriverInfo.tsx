import React from "react";

export interface DriverStats {
  name: string;
  level: number;
  experience: number;
}

export interface DriverInfoProps {
  driverStats: DriverStats | null;
  theme: string;
}

const DriverInfo: React.FC<DriverInfoProps> = ({ theme, driverStats }) => {
  if (!driverStats) return null;

  return (
    <div
      className={`driver-info p-6 rounded-lg shadow-lg ${theme === "light" ? "bg-white text-black" : "bg-gray-800 text-white"}`}
    >
      <h2 className="mb-4 font-bold text-2xl">Driver Info</h2>
      <p className="mb-2">
        <strong>Name:</strong> {driverStats.name}
      </p>
      <p className="mb-2">
        <strong>Level:</strong> {driverStats.level}
      </p>
      <p className="mb-2">
        <strong>Experience:</strong> {driverStats.experience}
      </p>
    </div>
  );
};

export default DriverInfo;
