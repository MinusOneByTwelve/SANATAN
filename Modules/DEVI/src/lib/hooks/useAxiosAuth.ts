import { useEffect } from "react";
import { axiosAuth } from "../axios";
import { useSessionStorage } from "usehooks-ts";
import { ISession } from "../../interfaces";

const useAxiosAuth = () => {
  const [value] = useSessionStorage("SESSION_USER", {});

  useEffect(() => {
    const requestIntercept = axiosAuth.interceptors.request.use((config) => {
      if (!config.headers.Authorization) {
        config.headers.Authorization = `Bearer ${
          (value as ISession)?.user?.accessToken
        }`;
      }

      return config;
    });
    return () => {
      axiosAuth.interceptors.request.eject(requestIntercept);
    };
  }, [value]);

  return axiosAuth;
};

export default useAxiosAuth;
