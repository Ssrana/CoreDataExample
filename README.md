# CoreDataExample
The project is made with following requirements:

 1.The app will land in a page listing all the records you have created with monitor on top. (First time it will be empty).
 2. User will click the "+" button on top it will open one view having fields like (*see the attachments 02 Screen.png)
  i.  Profile pic, It will pick image from gallery or capture image using mobile camera. (Required field)
  ii.  Name is a TextField  (Required field)
  iii. Designation is a TextField (Optional field)
  iv. DOB is a UIDatePicker field, required fields and range from 1/1/1980 to  1/1/2000 (Optional field)
  v. Address is a TextView (Optional field)
  vi. Gender is a PickerView/Tableview with single selection. Options are  [Male,Female,Other] , (Required field)
  vii. Hobbies field will open a TableViewController and user can select multiple options. ["Cricket","Football","Coding","Reading","Listing Music","Watching Movies","Swimming" etc],
     (Optional field)
So here you fill the form and and on Submit button click save the data in local db and come back to the first page.

3. User can click the existing records to view the details. (*see the attachments 03 Screen.png)
4. User can edit and delete the record.
5. Show the monitors like total number of records, total number of today's records.
6. Implement search.
7. Implement the sorting by name, dob, designation. (*see the attachments 01 Screen.png)
