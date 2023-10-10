# Read a file and print the lines
# file name: letra.txt

arreglo = []
f = open("letra.txt", "r")
fw = open("letraJava.txt", "w")
fw.write("ArrayList<String> letraFila = new ArrayList<String>();\n")
line = f.readline().strip()
while(len(line) > 0):
    for word in line:
        fw.write("letraFila.add(\"" + word.lower() + "\");\n")
    fw.write("letraCancion.add(letraFila);\n")
    fw.write("letraFila = new ArrayList<String>();\n")
    line = f.readline().strip()
f.close()
fw.close()