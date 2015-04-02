var searchForm = document.getElementById("tweetmapperSearch");
searchForm.addEventListener("submit", searchTerm, false);

function searchTerm() {
  var searchResult = document.getElementById("searchResult");
  searchResult.innerHTML = "Loading your tweetmapper search results";
}
