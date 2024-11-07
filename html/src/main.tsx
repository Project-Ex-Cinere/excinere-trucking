import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import TruckingSimulatorUI from "./App.tsx";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <div
      className="flex justify-center items-center bg-transparent min-w-screen min-h-screen"
      id="main_container"
    >
      <TruckingSimulatorUI />
    </div>

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
    ></link>
  </StrictMode>,
);
