root = exports ? this

fisheye = (canvas_id, xrad, yrad, origX, origY) ->
    origX = parseFloat(origX)
    origY = parseFloat(origY)
    rad = parseFloat(rad)

    canvas = document.getElementById(canvas_id)
    ctx = canvas.getContext("2d")
    ctx.drawImage window.bob, 0, 0, canvas.width, canvas.height
    
    width = canvas.width
    console.log "width "+width
    height = canvas.height
    console.log "height "+height

    # various idevices have fov between 40-60 degrees, focal length 4mm
    thetaX = (xrad * 150 * Math.PI/180)/width
    thetaY = (yrad * 210 * Math.PI/180)/width

    # # create backing canvas
    backCanvas = document.createElement('canvas');
    backCanvas.width = canvas.width;
    backCanvas.height = canvas.height;
    backCtx = backCanvas.getContext('2d');

    # # save main canvas contents, probably faster than copying to dorig array
    backCtx.drawImage(canvas, 0,0);
    backdataContainer = ctx.getImageData(0, 0, width, height)
    dorig = backdataContainer.data

    ctx.save()
    ctx.fillStyle = "black"
    ctx.fillRect(0,0,canvas.width,canvas.height)    
    ctx.restore()
    dataContainer = ctx.getImageData(0, 0, width, height)
    data = dataContainer.data    

    dim = width * height * 4
    console.log "fisheye dim w*h*4 " + dim + " data.length " + data.length


    halfw = width/2
    halfh = height/2
    i = 0 
    while (i < height)
        j = 0
        while (j < width)
            ipix = (i * width + j) * 4
            # console.log 'x,y,origx,origy',j,i,origX,origY
            nx = (j - origX)/width 
            ny = (i - origY)/height
            z = Math.sqrt(1.0 - nx*nx - ny*ny)
            aX = 1.0 / ( z * Math.tan(thetaX * 0.5) )
            aY = 1.0 / ( z * Math.tan(thetaY * 0.5) )
            newx = parseInt(nx * aX + origX,10)
            newy = parseInt(ny * aY + origY,10)
            # newy = parseInt(i,10)
            # console.log 'orig x,y',j,i,'new x,y',newx,newy
            if (width > newx >= 0) and (height > newy >= 0 )
                # console.log 'x,y',j,i,'new x,y',newx,newy
                opix = (newy * width + newx) * 4
                data[ipix] = dorig[opix]
                data[ipix+1] = dorig[opix+1]
                data[ipix+2] = dorig[opix+2]
                data[ipix+3] = dorig[opix+3]
            j++
        i++
    ctx.putImageData dataContainer, 0, 0
    false

root.fisheye = fisheye
