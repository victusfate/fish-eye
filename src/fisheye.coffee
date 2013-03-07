root = exports ? this

fisheye = (canvas_id, rad, origX, origY) ->
    canvas = document.getElementById(canvas_id)
    ctx = canvas.getContext("2d")
    ctx.drawImage window.bob, 0, 0, canvas.width, canvas.height
    
    width = canvas.width
    console.log "width "+width
    height = canvas.height
    console.log "height "+height

    # various idevices have fov between 40-60 degrees, focal length 4mm
    theta = (50 * Math.PI/180)/width

    dataContainer = ctx.getImageData(0, 0, width, height)
    data = dataContainer.data

    dim = width * height * 4
    console.log "fisheye dim w*h*4 " + dim + " data.length " + data.length



    # create backing canvas
    backCanvas = document.createElement('canvas');
    backCanvas.width = canvas.width;
    backCanvas.height = canvas.height;
    backCtx = backCanvas.getContext('2d');

    # save main canvas contents, probably faster than copying to dorig array
    backCtx.drawImage(canvas, 0,0);
    backdataContainer = ctx.getImageData(0, 0, width, height)
    backData = backdataContainer.data

    dorig = []
    dorig.length = data.length

    i = 0
    while (i < dim)
        dorig[i] = data[i]
        dorig[i+1] = data[i+1]
        dorig[i+2] = data[i+2]
        dorig[i+3] = data[i+3]
        i++


    i = 0 
    j = 0
    halfw = width/2
    halfh = height/2

    while (i < height)
        while (j < width)
            ipix = (i * width + j) * 4
            # console.log 'x,y,origx,origy',j,i,origX,origY
            nx = (j - origX)/width 
            ny = (i - origY)/height
            z = Math.sqrt(1.0 - nx*nx - ny*ny)
            a = 1.0 / ( z * Math.tan(theta * 0.5) )
            newx = nx * a * width
            newy = ny * a * height
            console.log 'orig x,y',j,i,'new x,y',newx,newy

            if (width > newx >= 0) and (height > newy >= 0 )
                opix = (newy * width + newx) * 4
                data[opix] = dorig[ipix]
                data[opix+1] = dorig[ipix+1]
                data[opix+2] = dorig[ipix+2]
                data[opix+3] = dorig[ipix+3]
            j++
        i++
    ctx.putImageData dataContainer, 0, 0
    false

root.fisheye = fisheye
