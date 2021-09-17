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

import jquery from 'jquery';
window.$ = window.jquery = jquery;

import 'bootstrap'

import Swal from 'sweetalert2';
window.Swal = Swal;

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// stimulus and autocomplete config
const application = Application.start();
const context = require.context("packs/stimulus/controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

// custom js scriptsz
require('packs/custom/posts')
require('packs/custom/navbar-scroll')
require('packs/custom/notice-alert')
require('packs/custom/timezones')
require('packs/custom/confirm-modal')
