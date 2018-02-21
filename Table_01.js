Table = function(filename)
{
	var rowCount;

	this.filename = filename;
	this.data = loadData(this.filename);
	this.getRowCount = getRowCount;
	this.getRowIndex = getRowIndex;
	this.getRowName = getRowName;
	this.getString = getString;
	this.getString2 = getString2;
	this.getInt = getInt;
	this.getInt2 = getInt2;
	this.getFloat = getFloat;
	this.getFloat2 = getFloat2;
	
	function loadData(fileName)
	{	
		if (fileName == undefined)
			return "";
			//return new String[10][10];
		else
		{
			var r = $.ajax({type: "GET", url: fileName, async: false}).responseText;
			rows = r.split("\n") 
			var data = []
			
			for (var i = 0; i < rows.length; i++) {
			  //if (trim(rows[i]).length() == 0) {
			//	continue; // skip empty rows
			  //}
			  if (rows[i].substring(0,1) == "#") {
				continue;  // skip comment lines
			  }

		      // split the row on the tabs
		      pieces = rows[i].split("\t"); //split(rows[i], TAB);
		      // copy to the table array
		      data[i] = pieces;
	      
		      // this could be done in one fell swoop via:
		      //data[rowCount++] = split(rows[i], TAB);
		    }
		    // resize the 'data' array as necessary
			rowCount = data.length;
			return data;
		}
	}
	
	function getRowCount() {
		return rowCount;
	}	
	
	// find a row by its name, returns -1 if no row found
	function getRowIndex(name) {
		for (var i = 0; i < rowCount; i++) {
	      if (this.data[i][0].toUpperCase() == name.toUpperCase()) {
	        return i;
	      }
	    }
	    alert("No row named '" + name + "' was found");
	    return -1;
	}	
	
	function getRowName(row) {
	   return this.getString(row, 0);
	}

	function getString(rowIndex, column) {
	  if (isNaN(rowIndex))
			return this.getString2(rowIndex, column);
		else
			return this.data[rowIndex][column];
	}

	function getString2(rowName, column) {
	    return this.getString(this.getRowIndex(rowName), column);
	}	

	  function getInt(rowIndex, column) {
		if (isNaN(rowIndex))
			return this.getInt2(rowIndex, column)
		else
			return parseInt(this.getString(rowIndex, column));
	  }
	  
	function getInt2(rowName, column) {
	    return parseInt(this.getString(rowName, column));
	}

	  
	function getFloat(rowIndex, column) {
		if (isNaN(rowIndex))
			return this.getFloat2(rowIndex, column)
		else
			return parseFloat(this.getString(rowIndex, column));
	}
	  
	function getFloat2(rowName, column) {
	    return parseFloat(this.getString(rowName, column));
	}	
	
}
