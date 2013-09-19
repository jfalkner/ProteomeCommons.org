function dataSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/dataSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/dataPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="dataAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setData(popupId, id, dataID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/dataBoxItem.jsp?prefix='+prefix+'&i='+dataID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function groupSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/groupSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/groupPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="groupAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setGroup(popupId, id, groupID, prefix) {
  // show the selection in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/groupBoxItem.jsp?prefix='+prefix+'&i='+groupID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function linkSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/linkSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/linkPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="linkAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setLink(popupId, id, linkID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/linkBoxItem.jsp?prefix='+prefix+'&i='+linkID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function newsSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/newsSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/newsPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="newsAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setNews(popupId, id, newsID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/newsBoxItem.jsp?prefix='+prefix+'&i='+newsID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function publicationSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/publicationSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/publicationPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="publicationAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setPublication(popupId, id, publicationID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/publicationBoxItem.jsp?prefix='+prefix+'&i='+publicationID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function toolSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/toolSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/toolPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="toolAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setTool(popupId, id, toolID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/toolBoxItem.jsp?prefix='+prefix+'&i='+toolID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}

function userSuggestion(boxItemId, textId, popupId, prefix) {
    // get the contents of the text box
    var text = getWebSafeString(getObj(textId).value);
    // do a quick search - how many results?
    ajax.get('@baseURLscripts/search/count/userSearchCount.jsp?l=1000&s='+text, function(r) {
      var textBox = getObj(textId);
      var popupFrame = getObj(popupId);
      // set the width of the popup frame equal to the width of the text box
      popupFrame.style.width = getWidth(textBox) + 'px';
      // set he location of the popup frame underneath the text box
      var textBoxPos = getPos(textBox);
      popupFrame.style.top = (textBoxPos[1] + getHeight(textBox)) + 'px';
      popupFrame.style.left = (textBoxPos[0]) + 'px';
      // show the popup frame
      showObj(popupFrame);
      // set the contents of the popup frame
      if (r <= 0) {
        // no results
        popupFrame.innerHTML = '<div>No results.</div>';
      } else if (r <= 25) {
        // if 25 or less, get the information and display it    
        ajax.update('@baseURLscripts/search/popup/userPopupSearch.jsp?prefix='+prefix+'&p=' + popupId + '&id=' + boxItemId + '&s=' + text, popupFrame);
      } else {
        popupFrame.innerHTML = '<div onclick="userAdvancedSearchFromPopup(\''+popupId+'\', \''+boxItemId+'\', \''+prefix+'\');" onmouseover="popupOptionOver(this);" onmouseout="popupOptionOut(this);">';
        // if 1000, the search was maxed out
        if (r == 1000) {
          popupFrame.innerHTML = popupFrame.innerHTML + 'At least ';
        }
        popupFrame.innerHTML = popupFrame.innerHTML + r + ' results.</div>';
      }
    });
}
function setUser(popupId, id, userID, prefix) {
  // show the user in the box item
  ajax.update('@baseURLscripts/references/add/items/selected/userBoxItem.jsp?prefix='+prefix+'&i='+userID, getObj(id));
  // hide the popup if open
  hide(popupId);
  // hide the popup page always
  hidePagePopup();
}