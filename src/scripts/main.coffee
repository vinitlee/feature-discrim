$( ->
  initialize()
  watch()
  # show('+','A')
)

R = {}

R.imageSrc = ["images/1.jpg",
            "images/2.jpg",
            "images/3.jpg",
            "images/4.jpg"]
R.names = ['A','B','C','D']

R.overlays = {}
R.overlays['+'] = 'images/markers/cross.png'
R.overlays['.'] = 'images/markers/dot.png'

R.images = {}
R.images['S'] = "images/S.jpg"
for n in R.names
  R.images[n] = ''

# Preloading images
for k,v of R.overlays
  im = new Image()
  im.src = v
for k,v of R.images
  im = new Image()
  im.src = v
for v in R.imageSrc
  im = new Image()
  im.src = v

initialize = ->
  if localStorage.init
    console.log('I recognize you. You\'ve been here before!')
    R.names = localStorage.names.split(',')
  else
    R.names.sort(() -> return 0.5-Math.random())
    localStorage.names = R.names
    localStorage.init = true
  for n,i in R.names
    R.images[n] = R.imageSrc[i]

show = (overlay='',image=false) ->
  if overlay is '.'
    R.clickable = true
  else
    R.clickable = false    

  if image in Object.keys(R.images)
    $('.image').css('background-image','url('+R.images[image]+')')
  else
    $('.image').css('background-image','none')
    
  if overlay in Object.keys(R.overlays)
    $('.overlay')
      .css('background-image','url('+R.overlays[overlay]+')')
      .html('')
  else
    $('.overlay')
      .css('background-image','none')
      .html(overlay)
  R.slideTime = Date.now()

# A slide consists of an image and an overlay; either may be null
R.slides = [{o:' ',i:'A'},
            {o:'.',i:'B'},
            {o:' ',i:'C'},
            {o:'.',i:'D'},
            {o:'+',i:'N'}]

showSlide = (slide) ->
  show(slide.o,slide.i)

# A scene consists of a series of slides
R.scenes = [[R.slides[0],R.slides[1],R.slides[2]],
            [{o:'+',i:''},{o:'',i:'A'},{o:'+',i:'B'},{o:'',i:'S'}]]

showScene = (scene,T,callback=(->false)) ->
  l = (i=0) ->
    showSlide(scene[i])
    if i+1 < scene.length
      setTimeout((->
        l(i+1)
      ),T)
    else
      callback()
  l()

R.clickable = false
R.slideTime = Date.now()
watch = ->
  $('.image').click(->
    console.log(Date.now()-R.slideTime+":"+R.clickable)
  )