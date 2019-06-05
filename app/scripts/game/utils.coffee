Q = Game.Q

Q.UI.Container::subplot = (nrows, ncols, rowFrom, colFrom, padding_fraction=0) ->
  return @subplot_multiple(nrows, ncols, rowFrom, colFrom, rowFrom, colFrom, padding_fraction)

Q.UI.Container::subplot_multiple = (nrows, ncols, rowFrom, colFrom, rowTo, colTo, padding_fraction=0) ->
  cell_w = @p.w/ncols
  cell_h = @p.h/nrows

  rowTo = rowFrom if rowTo is undefined
  colTo = colFrom if colTo is undefined  

  nRowsInSubplot = (1+rowTo-rowFrom)
  nColsInSubplot = (1+colTo-colFrom)

  x = @p.x - @p.w/2 + (colFrom+nColsInSubplot*0.5)*cell_w
  y = @p.y - @p.h/2 + (rowFrom+nRowsInSubplot*0.5)*cell_h

  fill = 1.0-padding_fraction;

  return new Q.UI.Container
          x: x
          y: y
          w: cell_w*nColsInSubplot*fill
          h: cell_h*nRowsInSubplot*fill