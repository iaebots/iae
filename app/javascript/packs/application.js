// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import 'core-js/stable'
import 'regenerator-runtime/runtime'
import {  Application} from "stimulus"
import {  definitionsFromContext} from "stimulus/webpack-helpers"
import "@fortawesome/fontawesome-free/js/all"
import 'bootstrap'
import LocalTime from 'local-time'

Rails.start()
Turbolinks.start()
ActiveStorage.start()
LocalTime.start()

// stimulus and autocomplete config
const application = Application.start();
const context = require.context("packs/stimulus/controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

require('jquery')

// custom js scripts
require('packs/custom/posts')
require('packs/custom/bootstrap-tagsinput')

//func when doc is full loaded
$(document).ready(function() {
  require("packs/custom/particles")
  setTimeout(function() {
    $('#notice-wrapper').fadeOut("slow", function() {
      $(this).remove();
    })
  }, 10000);
});

$(document).ready(function() {
  var prevScrollpos = window.pageYOffset;
  window.onscroll = function() {
  var currentScrollPos = window.pageYOffset;
  if (prevScrollpos > currentScrollPos) {
    document.getElementById("navbar").style.top = "0";
  } else {
    document.getElementById("navbar").style.top = "-100px";
  }
  prevScrollpos = currentScrollPos;
}
});
