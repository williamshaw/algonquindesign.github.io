"use strict"

navTop = $('.nav--top')
navBtn = $('.nav-btn')
navLinks = $('.nav--top a')
insideNav = false

openNav = () ->
  navTop.setAttribute('data-state', 'expanded')
  navBtn.setAttribute('data-state', 'active')

closeNav = () ->
  navTop.setAttribute('data-state', 'collapsed')
  navBtn.setAttribute('data-state', 'inactive')

toggleNav = () ->
  if navTop.getAttribute('data-state') is 'expanded'
    closeNav()
  else
    openNav()

waitToCloseNav = () ->
  setTimeout () ->
    closeNav() if not insideNav
  , 100

navBtn.on 'click', (e) ->
  e.preventDefault()
  toggleNav()

navBtn.on 'focus', (e) ->
  insideNav = true
  openNav()

navBtn.on 'blur', (e) ->
  insideNav = false
  waitToCloseNav()

navLinks.on 'focus', (e) ->
  insideNav = true
  openNav()

navLinks.on 'blur', (e) ->
  insideNav = false
  waitToCloseNav()

# Not sure if the Esc key is helpful or not for accessibility
# document.documentElement.on 'keyup', (e) ->
  # closeNav() if e.keyCode is 27
