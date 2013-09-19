// Author: James A Hill - augman85@gmail.com
var lastOpenMenu = '';
var lastOpenMenuBarOption = '';
var openMenu = '';
function showMenu(m,o) {
    reallyHideMenu(lastOpenMenu, lastOpenMenuBarOption);
    var menu = getObj(m);
    var pos = getPos(o);
    var height = getHeight(o);
    menuBarOptionOver(o);
    menu.style.left = (pos[0]) + 'px';
    menu.style.top = (pos[1]+height) + 'px';
    menu.style.display = 'block';
    openMenu = m;
    lastOpenMenu = m;
    lastOpenMenuBarOption = o;
}
function keepMenuOpen(m) {
    openMenu = m;
}
function reallyHideMenu(m,o) {
    if (openMenu != m) {
      menuBarOptionOut(o);
      getObj(m).style.display = 'none';
    }
}
function hideMenu(m,o) {
    openMenu = '';
    setTimeout('reallyHideMenu(\''+m+'\', getObj(\''+o+'\'));', 500);
}
function menuBarOptionOver(o) {
    o.style.background = '#ccc';
}
function menuBarOptionOut(o) {
    o.style.background = 'transparent';
}
function menuOptionOver(o) {
    o.style.background = '#ccc';
}
function menuOptionOut(o) {
    o.style.background = '#fff';
}