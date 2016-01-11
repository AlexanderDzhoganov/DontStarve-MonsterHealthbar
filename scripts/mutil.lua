function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return {
  firstToUpper = firstToUpper,
  trim = trim
}
