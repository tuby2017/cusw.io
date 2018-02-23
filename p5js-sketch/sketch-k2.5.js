var txt;
var nline;
var g;
var b;
var k = location.href;
function preload() {
//~	txt = loadStrings("url.txt");
	txt = loadStrings("x-lyrics.txt");
}

function setup(){
  noCanvas();
 createP(join(txt,"<br>")).addClass('text');
  g = 0;
  nline = selectAll('.text');
	for (var i=0; i < nline.length;i++){
		var n = nline[i].html();
//~		var words = n.split(/(\s+)/);
		var words = n.split(" ");
		for (var j=0; j < words.length;j++){
			var spanWord = createA('#'+j,words[j]+ " "); //createA('url','string')
			//~ var spanWord = createButton(words[j]);
		}
	}
	var z = select('p');
	z.hide();
	z = selectAll('a');
	for (var i=0; i < z.length;i++){
		//z[i].attribute('tabindex', i)
		z[i].attribute('id', i);
//~		z[i].attribute('class', 'z')
	}
	b = selectAll('a');
}
function keyPressed() {
//function keyIsDown() {
	 if (g > b.length || isNaN(g)){ g = 0}
		if (g < 0) { g = b.length}
	if (keyIsDown(RIGHT_ARROW)) {g = g+1}
	if (keyCode === 77 || key === 'm'|| key === '2') {g = g+1} //m or 2
	if (keyIsDown(LEFT_ARROW)) {
			g = g-1
	}
	if (keyCode === 66 || key === 'b'||key === '1'){g=g-1}
	if (keyIsDown(ENTER)) { g=0 ;//return false;
		}
	window.location.href = k+'#'+g; //goto this
//	console.log(g);
}

function mouseClicked() {
//	window.location.href
//	g = alert(this.id);//console.log(this.id());
	g = parseInt(document.activeElement.id)
//	console.log(g);
}

function draw(){
	noLoop();
//	 if (g > b.length || isNaN(g)){ g = 0}
//		if (g < 0) { g = b.length}
//if (keyIsDown(RIGHT_ARROW)) {g = g+1}
//	if (keyIsDown(LEFT_ARROW)) {g = g-1}
//	if (keyIsDown(ENTER)) { g=0 ;//return false;}
//	window.location.href = k+'#'+g; //goto this
//clear();
}
