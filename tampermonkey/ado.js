/* Before use */

// API requires alias email, update reviewer list here.
const reviewersAliasEmailList = [];
const apiVersion = "7.1-preview.1";
const apiVersionQuery = `?api-version=${apiVersion}`;

GM_registerMenuCommand(`Add Reviewers`, function () {
  addReviewers();
});

function addAllButtons() {
  addPRButtons();
  hackWorkItemPage();
}

function addPRButtons() {
  "use strict";
  if (!window.location.href.includes("/pullrequest/")) return;
  console.log("#####, add buttons to PR page");
  doUntilElementVisible("#tamper-util-row", 300, function () {
    addUtilityRow();
    addCopyBranchButton();
    addCopyPRNumberButton();
    addReviewerButton();
    addQueueBuildButton();
    addQueueExpiredButton();
  });
}

function addUtilityRow() {
  const prHeader = document.getElementsByClassName("repos-pr-header")[0];
  const utilityRow = document.createElement("div");
  utilityRow.id = "tamper-util-row";
  utilityRow.style.display = "flex";
  utilityRow.style.justifyContent = "center";

  prHeader.parentNode.insertBefore(utilityRow, prHeader.nextSibling);
}

function addQueueExpiredButton() {
  if (document.getElementById("queue-expired-btn")) {
    console.log("#####, queue expired button already added");
    return;
  }
  const { apiUrl, prId } = parsePRUrl();

  var qbbtn = document.createElement("button");
  qbbtn.id = "queue-expired-btn";
  qbbtn.innerHTML = "Queue expired";
  qbbtn.style.cursor = "pointer";
  qbbtn.onclick = () => {
    queueExpired(apiUrl, prId);
    qbbtn.innerHTML = "Queue expired ✓";
  };
  getPrUtilityRow().appendChild(qbbtn);
}

function addQueueBuildButton() {
  if (document.getElementById("queue-build-btn")) {
    console.log("#####, queue build button already added");
    return;
  }
  const { apiUrl, prId } = parsePRUrl();

  var qbbtn = document.createElement("button");
  qbbtn.id = "queue-build-btn";
  qbbtn.innerHTML = "Queue build";
  qbbtn.style.cursor = "pointer";
  qbbtn.onclick = () => {
    queueBuild(apiUrl, prId);
    qbbtn.innerHTML = "Queue build ✓";
  };
  getPrUtilityRow().appendChild(qbbtn);
}

function queueExpired(apiUrl, prId) {
  console.log("#####, queueing build...");
  fetch(`${apiUrl}/git/pullRequests/${prId}/${apiVersionQuery}`)
    .then((res) => res.json())
    .then(async (pr) => {
      const artifactId = `vstfs:///CodeReview/CodeReviewId/${pr.repository.project.id}/${pr.pullRequestId}`;
      const res = await fetch(
        `${apiUrl}/policy/evaluations/${apiVersionQuery}&artifactId=${artifactId}`,
      );
      return await res.json();
    })
    .then((res) => {
      console.log("Evaluations result: ", res.value);

      const filteredEvaluations = res.value.filter(
        (e) =>
          e.configuration.isBlocking &&
          e.configuration.settings.buildDefinitionId &&
          (e.context?.isExpired ||
            (e.context?.buildId ?? 0) === 0 ||
            e.status === "rejected"),
      );
      console.log(
        "Evaluations to queue: ",
        filteredEvaluations.map((e) => [
          e.configuration.settings.displayName,
          e,
        ]),
      );
      return Promise.all(
        filteredEvaluations.map((e) =>
          fetch(
            `${apiUrl}/policy/evaluations/${e.evaluationId}/${apiVersionQuery}`,
            {
              method: "patch",
            },
          ),
        ),
      );
    })
    .then(console.log)
    .catch(console.error);
}

function queueBuild(apiUrl, prId) {
  console.log("#####, queueing build...");
  fetch(`${apiUrl}/git/pullRequests/${prId}/${apiVersionQuery}`)
    .then((res) => res.json())
    .then(async (pr) => {
      const artifactId = `vstfs:///CodeReview/CodeReviewId/${pr.repository.project.id}/${pr.pullRequestId}`;
      const res = await fetch(
        `${apiUrl}/policy/evaluations/${apiVersionQuery}&artifactId=${artifactId}`,
      );
      return await res.json();
    })
    .then((res) => {
      console.log("Evaluations result: ", res.value);

      const filteredEvaluations = res.value.filter(
        (e) =>
          e.configuration.isBlocking &&
          e.configuration.settings.buildDefinitionId,
      );

      return Promise.all(
        filteredEvaluations.map((e) =>
          fetch(
            `${apiUrl}/policy/evaluations/${e.evaluationId}/${apiVersionQuery}`,
            {
              method: "patch",
            },
          ),
        ),
      );
    })
    .then(console.log)
    .catch(console.error);
}

function doUntilElementVisible(selector, time, callback) {
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
  var prNumBtn = document.createElement("button");
  prNumBtn.id = "cpy-pr-btn";
  const matches = window.location.href.match(
    /[^\d]+\/pullrequest\/(\d+)[^\d]*/,
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
    getPrUtilityRow().appendChild(prNumBtn);
  }
}

function getPrUtilityRow() {
  return document.getElementById("tamper-util-row");
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
  getPrUtilityRow().appendChild(copyBtn);
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

  addAllButtons();
  window.addEventListener("locationchange", () => {
    addAllButtons();
  });
})();

function hackWorkItemPage() {
  if (!window.location.href.includes("/_workitems")) {
    return;
  }
  console.log("####, hack work item page");
  doUntilElementVisible("#copyCifxTestNameButton", 300, function () {
    addCopyCifxTestNameButton();
    makeWorkItemNumClickable();
  });
}

function makeWorkItemNumClickable() {
  if (!window.location.href.includes("_workitems")) {
    return;
  }
  console.log("####, make work item number clickable");
  const workItemNumberEle = document.querySelector('[aria-label="ID Field"]');

  if (!workItemNumberEle) {
    setTimeout(() => {
      makeWorkItemNumClickable();
    }, 300);
    return;
  }
  workItemNumberEle.style.cursor = "pointer";
  workItemNumberEle.onclick = () => {
    const type = "text/plain";
    const workItemNumber = workItemNumberEle.innerHTML.match(/\d+/)[0];
    const blob = new Blob([workItemNumber], { type });
    const data = [new ClipboardItem({ [type]: blob })];
    navigator.clipboard.write(data);
    workItemNumberEle.innerHTML += " ✓";

    if (window.cifxDashboard) {
      window.open(window.cifxDashboard, "_blank");
    }
  };
}

function addCopyCifxTestNameButton() {
  if (
    !window.location.href.includes("_workitems") ||
    document.getElementById("copyCifxTestNameButton")
  ) {
    return;
  }
  console.log("####, add copy cifx test name button");
  const workItemTitle = document.getElementById("witc_1_txt");
  if (!workItemTitle || !workItemTitle.value) {
    setTimeout(() => {
      addCopyCifxTestNameButton();
    }, 300);
    return;
  }
  const testCaseName = workItemTitle.value.match(/(.*\))\sis.*/)[1];
  const copyCifxTestNameButton = document.createElement("button");
  copyCifxTestNameButton.innerHTML = "CIFX";
  copyCifxTestNameButton.id = "copyCifxTestNameButton";
  copyCifxTestNameButton.className = "copy-workitem-title-container";
  copyCifxTestNameButton.style.marginRight = "40px";
  copyCifxTestNameButton.style.padding = "0px";
  copyCifxTestNameButton.style.cursor = "pointer";
  copyCifxTestNameButton.onclick = () => {
    const type = "text/plain";
    const blob = new Blob([testCaseName], { type });
    const data = [new ClipboardItem({ [type]: blob })];
    navigator.clipboard.write(data);
    workItemTitle.innerHTML += " ✓";
  };
  document
    .getElementById("vss_5")
    .parentElement.insertBefore(
      copyCifxTestNameButton,
      document.getElementById("vss_5"),
    );
}

function addReviewers() {
  const { domain: serverUrl, prId: prIdStr } = parsePRUrl();

  getProjectAndRepoIds()
    .then((ids) => {
      reviewersAliasEmailList.map((email) =>
        getUserId(email, serverUrl).then((userId) =>
          addUserToReviewersById(ids[0], ids[1], userId, prIdStr, serverUrl),
        ),
      );
    })
    .catch((error) => {
      console.log("Failed to get project Id or repositoryId", error);
    });
}

async function getUserId(email, serverUrl) {
  var identityHeaders = new Headers();
  identityHeaders.append("content-type", "application/json");
  identityHeaders.append(
    "accept",
    "application/json;excludeUrls=true;enumsAsNumbers=true;msDateFormat=true;noArrayWrap=true",
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

  try {
    const response = await fetch(
      `${serverUrl}/_apis/IdentityPicker/Identities/${apiVersionQuery}`,
      identityRequestOptions,
    );
    const data = await response.json();
    return data.results[0].identities[0].localId;
  } catch (error) {
    return console.log("getUserId failed", error);
  }
}

function addUserToReviewersById(
  projectId,
  repositoryId,
  userId,
  prId,
  serverUrl,
) {
  var addReviewerHeaders = new Headers();
  addReviewerHeaders.append("content-type", "application/json");
  addReviewerHeaders.append(
    "accept",
    "application/json;excludeUrls=true;enumsAsNumbers=true;msDateFormat=true;noArrayWrap=true",
  );
  var addReviewerRequestOptions = {
    method: "put",
    headers: addReviewerHeaders,
    body: JSON.stringify({ localId: userId }),
  };

  fetch(
    `${serverUrl}/${projectId}/_apis/git/repositories/${repositoryId}/pullRequests/${prId}/reviewers/${userId}/${apiVersionQuery}`,
    addReviewerRequestOptions,
  )
    .then((response) => response.text())
    .then((result) => console.log(result))
    .catch((error) => console.log("addUserToReviewers failed", error));
}

var prPageResponseText;

// Get the project id and repository id which the current page is located on.
async function getProjectAndRepoIds() {
  const result_1 = await (Boolean(prPageResponseText)
    ? Promise.resolve(prPageResponseText)
    : fetch(window.location.href).then((response) => {
        prPageResponseText = response.text();
        return prPageResponseText;
      }));
  var projectId = result_1.match(
    /(\"project\"\:\{\"id\"\:\")([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})/,
  )[2];
  var repositoryId = result_1.match(
    /(\"gitRepository\"\:\{\"id\"\:\")([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})/,
  )[2];
  return [projectId, repositoryId];
}

function parsePRUrl() {
  //https://dev.azure.com/org/project/_git/repo/pullrequest/prId
  //https://org.visualstudio.com/project/_git/repo/pullrequest/prId
  const [, domain, project, repo, prId] = location.href.match(
    /(https:\/\/.*)\/([^\/]+)\/_git\/([^\/]+)\/pullrequest\/(\d+)/,
  );
  return { apiUrl: `${domain}/${project}/_apis`, domain, project, repo, prId };
}
