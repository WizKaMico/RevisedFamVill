$(document).ready(function () {
  const tableIds = [
    "#usersTable",
    "#accountBilling",
    "#payIntegrationTable",
    "#serviceTable",
    "#productsTable",
    "#upcomingTable",
    "#cartTable",
    "#activityTable",
    "#activityScheduling",
    "#activityPatient",
    "#sRoleTable",
    "#activityFeedback",
    "#activitySchedulingFollowup",
    "#businessTable",
  ];

  tableIds.forEach((id) => new DataTable(id));
});
