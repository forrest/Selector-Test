document.observe("dom:loaded", function(){
  $$("*[cm_css_path]").each(function(elm){
    
    //add hover effect
    elm.observe("mouseover", function(e){
      elm = Event.extend(e).element();
      elm.addClassName("cm_hovered");
      return false;
    });
    elm.observe("mouseout", function(){
      $$(".cm_hovered").invoke("removeClassName", "cm_hovered");
      return false;
    });
    
    elm.observe("click", function(e){
      elm = Event.extend(e).element();
      window.parent.document.selector_requested(elm.readAttribute("cm_css_path"), elm.readAttribute("cm_xpath"));
      return false;
    });
    
  });
});

function select_xpath(xpath){
  $$(".cm_selected").invoke("removeClassName","cm_selected");
  $$(xpath).invoke("addClassName", "cm_selected");
}
document.select_xpath = select_xpath;