const DIM_Y=100;
const SLEEP_MILLIS=100;

const MARGIN=19;
const CANVAS_Y=document.documentElement.clientHeight-MARGIN;
const CANVAS_X=document.documentElement.clientWidth-MARGIN;

//CANVAS_Y=1000
//CANVAS_X=2000
const DIM_X=DIM_Y*Math.round(CANVAS_X/CANVAS_Y);
const CELLSIZE_X=CANVAS_X/DIM_X;
const CELLSIZE_Y=CANVAS_Y/DIM_Y;

const COLOUR_ALIVE='aquamarine'
const COLOUR_DEAD='#66b0ff'

let svg_cells;
async function gameoflife(seed) {
    let state=seed;
    let oldstate=seed;
    svg_cells = init_drawing(state)
    while(true) {
      showState(state,oldstate)
      oldstate=state
      state=newState(state);
      await sleep(SLEEP_MILLIS)
    }
}

function init_drawing(seed) {
  const draw = SVG('drawing').size(CANVAS_X, CANVAS_Y).attr({style:"background-color: "+COLOUR_DEAD});

  const cells = array2d(DIM_X,DIM_Y);
  for (let y = 0; y < cells.length; y++) {
      for (let x = 0; x < cells[y].length; x++) {
          const fill=seed[y][x] ? COLOUR_ALIVE : COLOUR_DEAD;
          cells[y][x]= draw.rect(CELLSIZE_X, CELLSIZE_Y).attr({ x:x*CELLSIZE_X, y:y*CELLSIZE_Y, fill: COLOUR_DEAD });
      }
  }
  return cells;
}

function drawState(x,y,isLive) {
    svg_cells[y][x].fill(isLive ? COLOUR_ALIVE : COLOUR_DEAD)
}

function showState(state,oldstate) {
    //console.log(JSON.stringify(state))
    for (let y = 0; y < state.length; y++) {
        for (let x = 0; x < state[0].length; x++) {
            if (state[y][x] !== oldstate[y][x]) drawState(x,y,state[y][x]);
        }
    }
}

function newState(oldState) {
    const newgen=array2d(oldState[0].length,oldState.length);
    for (let y = 0; y < oldState.length; y++) {
        for (let x = 0; x < oldState[y].length; x++) {
            const count=countLiveNeighBours(x,y,oldState);
            let cellState=oldState[y][x];
            if (count<2 || count > 3) cellState=0;
            if (count === 3) cellState=1;
            newgen[y][x] = cellState;
        }
    }
    return newgen
}

function countLiveNeighBours(xin, yin, state) {
    let livecount=0;

    const startY=Math.max(yin-1,0);
    const endY=Math.min(state.length-1,yin+1);
    const startX=Math.max(xin-1,0);
    const endX=Math.min(state[0].length-1,xin+1);

    for (let y = startY; y <= endY; y++) {
        for (let x = startX ; x <= endX; x++) {
            if (y == yin && x == xin) continue;
            if (state[y][x]) livecount++;
        }
    }
    return livecount;
}

function array2d(dimx,dimy,fill=null) {
  const retval=new Array(dimy)
  for (let x = 0; x < retval.length; x++) {
    retval[x]=new Array(dimx);
    if(fill !== null) retval[x].fill(fill);
  }
  return retval;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function init_random(kernelx=DIM_X,kernely=DIM_Y,probfactor=0.75) {
   const seed = array2d(DIM_X,DIM_Y)
    for (let y = 0; y < seed.length; y++) {
        for (let x = 0; x < seed[y].length; x++) {
            let live = x >= DIM_X/2-kernelx/2 && x <= DIM_X/2+kernelx/2 && y >= DIM_Y/2-kernely/2 && y <= DIM_Y/2+kernely/2
            seed[y][x]= Math.round(Math.random()*probfactor)*live;
        }
    }
    return seed;
}

function init_kernel(kernelx=DIM_X/2,kernely=DIM_Y/2) {
   const seed = array2d(DIM_X,DIM_Y)
    for (let y = 0; y < seed.length; y++) {
        for (let x = 0; x < seed[y].length; x++) {
            let live = x > DIM_X/2-kernelx/2 && x < DIM_X/2+kernelx/2 && y > DIM_Y/2-kernely/2 && y < DIM_Y/2+kernely/2
            seed[y][x]= live;
        }
    }
    return seed;
}

//gameoflife(init_kernel(DIM_X/25,DIM_Y/25));
//gameoflife(init_kernel(120,60));
//gameoflife(init_kernel(2*DIM_X/3,2*DIM_Y/3));
gameoflife(init_random(2*DIM_X/3,2*DIM_Y/3));
