import React from "react";

interface ConfirmationModalProps {
  theme: string;
  show: boolean;
  message: string;
  onConfirm: () => void;
  onCancel: () => void;
}

const ConfirmationModal: React.FC<ConfirmationModalProps> = ({
  theme,
  show,
  message,
  onConfirm,
  onCancel,
}) => {
  if (!show) return null;

  return (
    <div className="fixed inset-0 flex justify-center items-center bg-black bg-opacity-50 modal-overlay">
      <div
        className={`modal p-6 rounded-lg text-center w-80 ${
          theme === "light" ? "bg-white text-black" : "bg-gray-900 text-white"
        }`}
      >
        <p className="mb-6">{message}</p>
        <div className="flex justify-center gap-4">
          <button
            className={`px-4 py-2 rounded ${
              theme === "light"
                ? "bg-green-500 text-white"
                : "bg-green-700 text-white"
            }`}
            onClick={onConfirm}
          >
            Yes
          </button>
          <button
            className={`px-4 py-2 rounded ${
              theme === "light"
                ? "bg-red-500 text-white"
                : "bg-red-700 text-white"
            }`}
            onClick={onCancel}
          >
            No
          </button>
        </div>
      </div>
    </div>
  );
};

export default ConfirmationModal;
