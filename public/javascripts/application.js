function selector_requested(css, xpath){
  $('css_selector').value = css;
  $('xpath_selector').value = xpath;
  xpath_changed(css);
}

document.selector_requested = selector_requested;

function xpath_changed(path){
  window.frames[0].select_xpath(path);
}