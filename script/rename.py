import os

def main():
    files = os.listdir()
    movieExt = "."+input("Enter movie file ext: ")
    subExt = "."+input("Enter subtitle file ext: ")
    for i in range(len(files)):
        files[i] = os.path.splitext(files[i])
    movList = sorted([file for file in files if file[1] == movieExt])
    subList = sorted([file for file in files if file[1] == subExt])

    if len(movList) == len(subList):
        for i in range(len(subList)):
            src = subList[i][0] + subExt
            dst = movList[i][0] + subExt
            os.rename(src, dst)
            print(src, dst)
        print("Done, %d subtitles name synced!"%len(movList))
    else:
        print("File numbers are not equivalent")

if __name__ == "__main__":
    main()
