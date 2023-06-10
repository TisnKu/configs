// ==UserScript==
// @name         ADO Buttons
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://dev.azure.com/*
// @match        https://*.visualstudio.com/*
// @icon         https://www.google.com/s2/favicons?domain=visualstudio.com
// @grant GM_registerMenuCommand
// @grant GM_xmlhttpRequest
// ==/UserScript==

/* Before use */

// API requires alias email, update reviewer list here.
const reviewersAliasEmailList = [];

GM_registerMenuCommand(`Add Reviewers`, function () {
  addReviewers();
});

function addButtons() {
  "use strict";
  if (!window.location.href.includes("/pullrequest/")) return;
  console.log("#####, add buttons to PR page");
  doUntilElementAdded("#cpy-pr-btn", 300, function () {
    addCopyBranchButton();
    addCopyPRNumberButton();
    addReviewerButton();
  });
}

function doUntilElementAdded(selector, time, callback) {
  var interval = setInterval(function () {
    var element = document.querySelector(selector);
    if (element) {
      clearInterval(interval);
    } else {
      callback();
    }
  }, time);
}

function addCopyPRNumberButton() {
  if (document.getElementById("cpy-pr-btn")) {
    console.log("#####, copy pr button already added");
    return;
  }
  var branchHeader = document.getElementsByClassName("pr-header-branches")[0];
  var prNumBtn = document.createElement("button");
  prNumBtn.id = "cpy-pr-btn";
  if (branchHeader && prNumBtn) {
    const matches = window.location.href.match(
      /[^\d]+\/pullrequest\/(\d+)[^\d]*/
    );
    if (matches) {
      const prNumber = matches[1];
      prNumBtn.innerHTML = "Copy PR Number";
      prNumBtn.style.cursor = "pointer";
      prNumBtn.onclick = () => {
        const type = "text/plain";
        const blob = new Blob([prNumber], { type });
        const data = [new ClipboardItem({ [type]: blob })];
        navigator.clipboard.write(data);
        prNumBtn.innerHTML = "Copy PR Number ✓";
      };
      branchHeader.appendChild(prNumBtn);
    }
  }
}

function addCopyBranchButton() {
  if (document.getElementById("cpy-branch-btn")) {
    console.log("#####, copy branch button already added");
    return;
  }
  var branchHeader = document.getElementsByClassName("pr-header-branches")[0];
  if (!branchHeader) return;
  var pr = branchHeader.children[0].innerText;
  var copyBtn = document.createElement("button");
  copyBtn.id = "cpy-branch-btn";
  copyBtn.innerHTML = "Copy Branch";
  copyBtn.style.cursor = "pointer";
  copyBtn.onclick = () => {
    const type = "text/plain";
    const blob = new Blob([pr], { type });
    const data = [new ClipboardItem({ [type]: blob })];
    navigator.clipboard.write(data);
    copyBtn.innerHTML = "Copy Branch ✓";
  };
  branchHeader.appendChild(copyBtn);
}

function addReviewerButton() {
  if (document.getElementById("add-reviewers-btn")) {
    console.log("#####, reviewer button already added");
    return;
  }

  var btn = document.createElement("button");
  btn.innerHTML = `Add all Reviewers`;
  btn.onclick = () => {
    addReviewers();
  };
  var addReviewerBtn = document.getElementById("__bolt-add-reviewer-menu");
  if (!addReviewerBtn) return;
  addReviewerBtn.parentNode.appendChild(btn);
}

(function () {
  (() => {
    if (window.__hookLocationChange) {
      return;
    }
    let oldPushState = history.pushState;
    history.pushState = function pushState() {
      let ret = oldPushState.apply(this, arguments);
      window.dispatchEvent(new Event("pushstate"));
      window.dispatchEvent(new Event("locationchange"));
      return ret;
    };

    let oldReplaceState = history.replaceState;
    history.replaceState = function replaceState() {
      let ret = oldReplaceState.apply(this, arguments);
      window.dispatchEvent(new Event("replacestate"));
      window.dispatchEvent(new Event("locationchange"));
      return ret;
    };

    window.addEventListener("popstate", () => {
      window.dispatchEvent(new Event("locationchange"));
    });
    window.__hookLocatinChange = true;
  })();

  addButtons();
  makeWorkItemNumClickable();
  window.addEventListener("locationchange", () => {
    addButtons();
    makeWorkItemNumClickable();
  });
})();

function makeWorkItemNumClickable() {
  if (!window.location.href.includes("_workitems")) {
    return;
  }
  console.log("####, make work item number clickable");
  const workItemNumber = document.querySelector('[aria-label="ID Field"]');

  if (!workItemNumber) {
    setTimeout(() => {
      makeWorkItemNumClickable();
    }, 300);
  }
  workItemNumber.style.cursor = "pointer";
  workItemNumber.onclick = () => {
    const type = "text/plain";
    const blob = new Blob([workItemNumber.innerHTML], { type });
    const data = [new ClipboardItem({ [type]: blob })];
    navigator.clipboard.write(data);
    workItemNumber.innerHTML += " ✓";
  };
}

function addReviewers() {
  var serverUrl;
  var repoStr;
  var prIdStr;
  // https://dev.azure.com/onedrive/ODSP-Web/_git/odsp-web/pullrequest/897318
  var match = location.href.match(
    /(https:\/\/[^\/]+)\/([^\/]+)\/([^\/]+)\/_git\/([^\/]+)\/pullrequest\/(\d+)/
  );
  if (match) {
    const [, domain, team, repo, , prId] = match;
    serverUrl = domain + "/" + team;
    repoStr = repo;
    prIdStr = prId;
  }

  //https://onedrive.visualstudio.com/ODSP-Web/_git/odsp-web/pullrequest/2834822
  match = location.href.match(
    /(https:\/\/[^\/]+)\/([^\/]+)\/_git\/([^\/]+)\/pullrequest\/(\d+)/
  );
  if (match) {
    const [, domain, , repo, prId] = match;
    serverUrl = domain;
    repoStr = repo;
    prIdStr = prId;
  }

  if (!serverUrl || !repoStr || !prIdStr) {
    alert("Current service not supported");
  }

  getProjectAndRepoIds()
    .then((ids) => {
      reviewersAliasEmailList.map((email) =>
        getUserId(email, serverUrl).then((userId) =>
          addUserToReviewersById(ids[0], ids[1], userId, prIdStr, serverUrl)
        )
      );
    })
    .catch((error) => {
      console.log("Failed to get project Id or repositoryId", error);
    });
}

function getUserId(email, serverUrl) {
  var identityHeaders = new Headers();
  identityHeaders.append("content-type", "application/json");
  identityHeaders.append(
    "accept",
    "application/json;api-version=5.0-preview.1;excludeUrls=true;enumsAsNumbers=true;msDateFormat=true;noArrayWrap=true"
  );
  var identityRequestOptions = {
    method: "POST",
    headers: identityHeaders,
    body: JSON.stringify({
      query: email,
      identityTypes: ["user", "group"],
      operationScopes: ["ims", "source"],
      options: { MinResults: 5, MaxResults: 40 },
      properties: [
        "DisplayName",
        "IsMru",
        "ScopeName",
        "SamAccountName",
        "Active",
        "SubjectDescriptor",
        "Department",
        "JobTitle",
        "Mail",
        "MailNickname",
        "PhysicalDeliveryOfficeName",
        "SignInAddress",
        "Surname",
        "Guest",
        "TelephoneNumber",
        "Manager",
        "Description",
      ],
    }),
  };

  return fetch(
    `${serverUrl}/_apis/IdentityPicker/Identities`,
    identityRequestOptions
  )
    .then((response) => response.json())
    .then((data) => data.results[0].identities[0].localId)
    .catch((error) => console.log("getUserId failed", error));
}

function addUserToReviewersById(
  projectId,
  repositoryId,
  userId,
  prId,
  serverUrl
) {
  var addReviewerHeaders = new Headers();
  addReviewerHeaders.append("content-type", "application/json");
  addReviewerHeaders.append(
    "accept",
    "application/json;api-version=5.0-preview.1;excludeUrls=true;enumsAsNumbers=true;msDateFormat=true;noArrayWrap=true"
  );
  var addReviewerRequestOptions = {
    method: "put",
    headers: addReviewerHeaders,
    body: JSON.stringify({ localId: userId }),
  };

  fetch(
    `${serverUrl}/${projectId}/_apis/git/repositories/${repositoryId}/pullRequests/${prId}/reviewers/${userId}`,
    addReviewerRequestOptions
  )
    .then((response) => response.text())
    .then((result) => console.log(result))
    .catch((error) => console.log("addUserToReviewers failed", error));
}

var prPageResponseText;

// Get the project id and repository id which the current page is located on.
function getProjectAndRepoIds() {
  return (
    Boolean(prPageResponseText)
      ? Promise.resolve(prPageResponseText)
      : fetch(window.location.href).then((response) => {
          prPageResponseText = response.text();
          return prPageResponseText;
        })
  ).then((result) => {
    var projectId = result.match(
      /(\"project\"\:\{\"id\"\:\")([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})/
    )[2];
    var repositoryId = result.match(
      /(\"gitRepository\"\:\{\"id\"\:\")([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})/
    )[2];
    return [projectId, repositoryId];
  });
}
