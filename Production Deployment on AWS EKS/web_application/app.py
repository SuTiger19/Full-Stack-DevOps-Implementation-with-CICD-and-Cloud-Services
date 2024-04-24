from flask import Flask, render_template, request
from pymysql import connections
import os
import boto3

app = Flask(__name__)

# Environment variables
DBHOST = os.environ.get("DBHOST", "localhost")
DBUSER = os.environ.get("DBUSER", "root")
DBPWD = os.environ.get("DBPWD", "password")
DATABASE = os.environ.get("DATABASE", "employees")
DBPORT = int(os.environ.get("DBPORT", 3306))
bucketname = os.environ.get("bucketname", "clo835group1")
bgimage = os.environ.get("backgroundimage", "background.png")
groupName = os.environ.get("groupName", "Group-1")

# Database connection
db_conn = connections.Connection(
    host=DBHOST,
    port=DBPORT,
    user=DBUSER,
    password=DBPWD,
    db=DATABASE
)

# S3 Client
s3_client = boto3.client('s3', region_name='us-east-1') 
# Directory for storing images
imagesDir = "static"
if not os.path.exists(imagesDir):
    os.makedirs(imagesDir)

def download(bucket=bucketname, imageName=bgimage):
    bgImagePath = os.path.join(imagesDir, imageName)
    try:
        s3_client.download_file(bucket, imageName, bgImagePath)
        log_msg = f"Successfully downloaded {imageName} from bucket {bucket} to {bgImagePath}"
        print(log_msg)
        # Assuming your static directory is directly accessible via the web server:
        return f"/static/{imageName}"
    except Exception as e:
        print(f"Exception occurred while fetching the image from S3: {e}")
        return None


image_url = download()
print(f"Background image URL: {image_url}")  

@app.route("/", methods=['GET', 'POST'])
def home():
    return render_template('addemp.html', image=image_url, group_name=groupName)

@app.route("/about", methods=['GET', 'POST'])
def about():
    return render_template('about.html', image=image_url, group_name=groupName)
    
@app.route("/addemp", methods=['POST'])
def AddEmp():
    emp_id = request.form['emp_id']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    primary_skill = request.form['primary_skill']
    location = request.form['location']

  
    insert_sql = "INSERT INTO employee VALUES (%s, %s, %s, %s, %s)"
    cursor = db_conn.cursor()

    try:
        
        cursor.execute(insert_sql,(emp_id, first_name, last_name, primary_skill, location))
        db_conn.commit()
        emp_name = "" + first_name + " " + last_name

    finally:
        cursor.close()

    print("all modification done...")
    return render_template('addempoutput.html', name=emp_name, image=image_url, group_name=groupName)

@app.route("/getemp", methods=['GET', 'POST'])
def GetEmp():
    return render_template("getemp.html", image=image_url, group_name=groupName)


@app.route("/fetchdata", methods=['GET','POST'])
def FetchData():
    emp_id = request.form['emp_id']

    output = {}
    select_sql = "SELECT emp_id, first_name, last_name, primary_skill, location from employee where emp_id=%s"
    cursor = db_conn.cursor()

    try:
        cursor.execute(select_sql,(emp_id))
        result = cursor.fetchone()
        
        output["emp_id"] = result[0]
        output["first_name"] = result[1]
        output["last_name"] = result[2]
        output["primary_skills"] = result[3]
        output["location"] = result[4]
        
    except Exception as e:
        print(e)

    finally:
        cursor.close()

    return render_template("getempoutput.html", id=output["emp_id"], fname=output["first_name"],
                           lname=output["last_name"], interest=output["primary_skills"], location=output["location"], image=image_url, group_name=groupName)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=81, debug=True)