const { graphql } = require("@octokit/graphql");

const User = require('../models/User');
const githubService = require('../services/githubService');
const { MONGOOSE_GITHUB_KEY } = require('../config/githubConfig');
const checkCount = require('./checkCount');

const graphqlRepositoryCount = (owner, _) => `{
    repositoryOwner(login:"${owner}") {
        repositories {
            totalCount
        }
    }
}`;

const graphqlOpenedIssues = (owner, name) => `{
    repository(owner:"${owner}", name:"${name}") {
        issues(states:OPEN) {
            totalCount
        }
    }
}`;

const graphqlClosedIssues = (owner, name) => `{
    repository(owner:"${owner}", name:"${name}") {
        issues(states:CLOSED) {
            totalCount
        }
    }
}`;

const graphqlPullRequests = (owner, name) => `{
    repository(owner:"${owner}", name:"${name}") {
        pullRequests {
            totalCount
        }
    }
}`;

const graphqlRefsCount = (owner, name) => `{
    repository(owner:"${owner}", name:"${name}") {
        refs(refPrefix: "refs/heads/") {
            totalCount
        }
    }
}`;

const graphqlTagCount = (owner, name) => `{
    repository(owner:"${owner}", name:"${name}") {
        refs(refPrefix: "refs/tags/") {
            totalCount
        }
    }
}`;

const QUERIES = {
    'new_repository': graphqlRepositoryCount,
    'new_issue': graphqlOpenedIssues,
    'issue_closes': graphqlClosedIssues,
    'new_pull_request': graphqlPullRequests,
    'new_ref': graphqlRefsCount,
    'new_tag': graphqlTagCount
}

async function getQueryCount(user, queryData, graphQuery) {
    const connectData = user.connectData.get(MONGOOSE_GITHUB_KEY);
    let count = undefined;

    if (!connectData) {
        throw "Not connected to github";
    }
    try {
        const graphResult = await graphql(graphQuery(queryData.owner, queryData.repo), {
            headers: {
                authorization: `Bearer ${connectData.accessToken}`,
            },
        });

        /* graphResult be like
            { repository:      { issues:       { totalCount: number } } } new_issue
            { repository:      { issues:       { totalCount: number } } } issue_closes
            { repository:      { pullRequests: { totalCount: number } } } new_pull_request
            { repositoryOwner: { repositories: { totalCount: number } } } new_repository
            ...
            du coup je fais un trick pour ne pas à faire des ifs or something
        */
        for (const obj in graphResult) {
            if (graphResult.hasOwnProperty(obj)) {
                const res = graphResult[obj];
                for (const data in res) {
                    if (res.hasOwnProperty(data)) {
                        count = res[data].totalCount;
                    }
                }
            }
        }
    } catch (err) {
        console.log(err);
        throw "Could not process query (maybe user/repo does not exist)";
    }
    if (count === undefined) {
        throw "Could not find anything in query response (maybe user/repo does not exist)";
    }
    return count;
}

async function githubTriggers(area, react) {
    const user = await User.findById(area.userId);
    const query = QUERIES[area.action.name];

    if (query) {
        await checkCount(area, () => getQueryCount(user, area.action.data, query), react);
    }
}

async function githubReact(area) {
    const user = await User.findById(area.userId);

    if (area.reaction.name === "open_issue") {
        const data = githubService.getUserData(user);

        try {
            await githubService.postNewIssue(area.reaction.data, data.accessToken);
        } catch (err) {
            console.log(err);
        }
    }
}

async function githubCheck(user, action) {
    const query = QUERIES[action.name];

    if (query) {
        try {
            await getQueryCount(user, action.data, query);
        } catch (err) {
            return err;
        }
        return false;
    }
    return "Could not find any query from action name (not supposed to happen)";
}

module.exports = {
    githubTriggers,
    githubReact,
    githubCheck
};
