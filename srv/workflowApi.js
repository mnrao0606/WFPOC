const axios = require("axios");
module.exports = {
  StartInstance: function (context, definitionId) {
    //Starts a new WF instance
    return StartInstance(context, definitionId);
  },
};

let StartInstance = function (context, definitionId) {
  //Starts the Workflow Instance. The beggining of the process
  console.log("Start Instance ----- before");
  return new Promise(function (resolve, reject) {
    const data = {
      definitionId: definitionId, //"requestforinformation",
      context: context,
    };

    axios
      .request({
        url: "/v1/workflow-instances",
        method: "POST",
        baseURL:
          "https://api.workflow-sap.cfapps.us10.hana.ondemand.com/workflow-service/rest",
        data: data,
      })
      .then((res) => {
        console.log("Instance " + res.data.id + " Created Successfully");
        resolve(res.data);
      })
      .catch((err) => {
        handleResponseError(err);
        reject(err);
      });
  });
};

let getAccessToken = () => {
  return new Promise(function (resolve, reject) {
    axios
      .request({
        url: "oauth/token",
        method: "POST",
        baseURL: "https://wfpoc-u6vo7fis.authentication.us10.hana.ondemand.com",
        auth: {
          username:
            "sb-clone-4617f24d-9aeb-4e20-b980-073c0f15d793!b151719|workflow!b1774",
          password:
            "8853e0ce-8f58-48d1-ab5c-e75007c0b46c$CnxpZrKST7JwN8YXn1vlSI3fc7lJHrdI2aUCEP0LxjI=",
        },
        params: {
          grant_type: "client_credentials",
        },
      })
      .then((res) => {
        console.log("Oauth Token Received");
        axios.defaults.headers.common["Authorization"] =
          "Bearer " + res.data.access_token;
        resolve(res.data.access_token);
      })
      .catch((error) => {
        console.error(error);
      });
  });
};

function handleResponseError(err) {
  console.error(err);

  if (err.response.status == 401) {
    //Token Expired
    console.log("Getting new token");
    getAccessToken();
  }
}

//First request to have the Oauth token saved
getAccessToken();
