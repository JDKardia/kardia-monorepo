function archiveGitNotifsThatArentRelevant() {
  const merged = GmailApp.search('label:inbox label:Fin ',0,100);
  GmailApp.moveThreadsToArchive(merged)
};
