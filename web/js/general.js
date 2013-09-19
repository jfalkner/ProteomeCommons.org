// Author: James A Hill - augman85@gmail.com
function getObj(n) {
  if (document.getElementById) {
    return document.getElementById(n);
  } else if (document.all) {
    return document.all[n];
  } else if (document.layers) {
    return document.layers[n];
  }
}
function getPos(o) {
  var curleft = curtop = 0;
  if (o.offsetParent) {
    do {
      curleft += o.offsetLeft;
      curtop += o.offsetTop;
    } while (o = o.offsetParent);
  }
  return [curleft,curtop];
}
function getWidth(elem) {
  function _Convert(val) {
    if (!val) {return;}
    val = val.replace("px","");
    if (isNaN(val)) {return 0;} 
    return parseInt(val);
  }
  var currentStyle;
  if (elem.currentStyle) { currentStyle = elem.currentStyle; }
  else if (window.getComputedStyle) {	currentStyle = document.defaultView.getComputedStyle(elem, null); }
  else { currentStyle = elem.style; }
  return (elem.offsetWidth -
    _Convert(currentStyle.marginLeft) -
    _Convert(currentStyle.marginRight) -
    _Convert(currentStyle.borderLeftWidth) -
    _Convert(currentStyle.borderRightWidth));
}
function getHeight(elem) {
  function _Convert(val) {
    if (!val) {return;}
    val = val.replace("px","");
    if (isNaN(val)) {return 0;}
    return parseInt(val);
  }
  var currentStyle;
  if (elem.currentStyle) { currentStyle = elem.currentStyle; }
  else if (window.getComputedStyle) {	currentStyle = document.defaultView.getComputedStyle(elem, null); }
  else { currentStyle = elem.style; }
  return (elem.offsetHeight -
    _Convert(currentStyle.marginTop) -
    _Convert(currentStyle.marginBottom) -
    _Convert(currentStyle.borderTopWidth) -
    _Convert(currentStyle.borderBottomWidth));
}
function getScreenSize() {
  var myWidth = 0, myHeight = 0;
  if (typeof(window.innerWidth) == 'number') {
    //Non-IE
    myWidth = window.innerWidth;
    myHeight = window.innerHeight;
  } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
    //IE 6+ in 'standards compliant mode'
    myWidth = document.documentElement.clientWidth;
    myHeight = document.documentElement.clientHeight;
  } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
    //IE 4 compatible
    myWidth = document.body.clientWidth;
    myHeight = document.body.clientHeight;
  }
  return [myWidth,myHeight];
}
function goTo(url) {
  document.location.href = url;
}
function showFrameTopRight(f,o,changeLeft,changeTop) {
  var frame = getObj(f);
  var pos = getPos(o);
  frame.style.left = (pos[0]+changeLeft) + 'px';
  frame.style.top = (pos[1]+changeTop) + 'px';
  showObj(frame);
}
function show(e) {
  getObj(e).style.display = 'block';
}
function showObj(e) {
  e.style.display = 'block';
}
function hide(e) {
    getObj(e).style.display = 'none';
}
function hideObj(e) {
    e.style.display = 'none';
}
function clear(e) {
    getObj(e).innerHTML = '';
}
function clearObj(e) {
    e.innerHTML = '';
}
function changeRegionSet(c,r) {
    // get the country ID
    var country = getObj(c);
    var countryID = country.options[country.selectedIndex].value;
    // get the new inner HTML for the region (AJAX) and send reponse to a function
    ajax.update("@baseURLscripts/location/selectRegions.jsp?c="+countryID, r);
}
function getWebSafeString(string) {
    string = string.replace("%", "%25");
    string = string.replace(" ", "%20");
    string = string.replace("!", "%21");
    string = string.replace("\"", "%22");
    string = string.replace("#", "%23");
    string = string.replace("&", "%26");
    string = string.replace("'", "%27");
    string = string.replace("+", "%2b");
    string = string.replace(",", "%2c");
    string = string.replace("/", "%2f");
    string = string.replace("=", "%3d");
    string = string.replace("?", "%3f");
    return string;
}
function popupOptionOver(o) {
    o.style.background = '#ccc';
}
function popupOptionOut(o) {
    o.style.background = '#fff';
}
function showPagePopup(url, title) {
  var pagePopup = getObj('pagePopup');
  pagePopup.innerHTML = '<table cellpadding="0" cellspacing="0" border="0" width="100%"><tr><td><b>'+title+'</b></td><td align="right"><span style="cursor: pointer;" onclick="hide(\'pagePopupContainer\');">Close</span></td></tr></table>';
  show('pagePopupContainer');
  ajax.append(url, pagePopup);
}
function hidePagePopup() {
  hide('pagePopupContainer');
}