var inputs = document.getElementsByClassName("icon-delete");
var i = 0,
  h = inputs.length;

function click() {
  inputs[i].click();
  i++;
  if (i < h) {
    setTimeout(click, 1000);
  }
}
click();
