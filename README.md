# UIDropDownTextField
UIDropDownTextField is a custom class that written to  draw / design an awesome Data Picker Controller with simple and easy approach. Developer can implement new Drop Down TextField with simple few steps and customize it with plenty of attributes using attributes inspector such as background, border color, separator color, font and font color etc. Class is based on Swift language and require UIKit framework for function the functionalities of the class.

<br />
<p align="center">
  <img src="https://github.com/NadeeshanEngineering/UIDropDownTextField/blob/master/the_demo.gif">
</p>

To use UIDropDownTextField in your project, please follow following steps

1. Add (or Drag and drop to Your project in Xcode) UIDropDownTextField.swift files to your project 

2. Add UIDropDownTextFieldDelegate to your ViewController class

	Ex:
      
          class ViewController: UIViewController, UIDropDownTextFieldDelegate

3. Declaring and initializing a IBOutlet UIDropDownTextField so an UITextField can hook from interface

	Ex:
      
          @IBOutlet var dropTextField: UIDropDownTextField!
          
4. Declaring and initializing an empty UIDropDownObject array so later can set drop down items from UIDropDownTextFieldDelegate datasource

      Ex:

          var socialMediaList: [UIDropDownObject] = [UIDropDownObject]()

5. Assign UIDropDownTextField class to your UITextField from Identity Inspector class  ->  Custom Class section in XCode

<br />
<p align="center">
  <img src="https://github.com/NadeeshanEngineering/UIDropDownTextField/blob/master/Screen_Shot_01.png">
</p>
<br />

6. Assign UIDropDownTextFieldDelegate to UIDropDownTextField instance at your ViewController class

	Ex:
      
          override func viewDidLoad() 
          {
                    dropTextField.dropDownDelegate = self  
          }

7. Add UIDropDownTextFieldDelegate datasource functions into your ViewController calss so you can catch set menu datasource to your UIDropDownTextField

	Ex:
      
          func dropDownTextField(_ dropDownTextField: UIDropDownTextField, didSelectRowAt indexPath: IndexPath) 
          {
                    let aDropDownObject: UIDropDownObject = socialMediaList[indexPath.row];
                    print("Great! You just select \(aDropDownObject.title) from UIDropDownTextField.")
              
                    // Or
              
                    print("Great! You can get selected text of \(dropTextField.text()) from UIDropDownTextField.")
                    print("Great! You can get selected value of \(dropTextField.value()) from UIDropDownTextField.")
          }
          
          // Mark - Initializing drop down items in UIDropDownTextField datasource
          
          func dropDownTextField(_ dropDownTextField: UIDropDownTextField, setOfItemsInDropDownMenu items: [UIDropDownObject]) -> [UIDropDownObject] 
          {
                    return socialMediaList
          }
 
 8. Initializing a new UIDropDownObject with object using previous UIDropDownObject variable
 
     Ex:
     
           override func viewDidLoad() 
           {
                   let facebook = UIDropDownObject(title: "Facebook", value: "Facebook", icon: UIImage.init(named: "ic_facebook"))
                   
                   let linkedin = UIDropDownObject(title: "Linked in", value: "Linked in", icon: UIImage.init(named: "ic_linkedin"))
                   
                   
                   socialMediaList = [facebook,linkedin]
           }
 
 8. Use IBInspectable properties to customize your awesome UIDropDownTextField at Attribute Inspector panel in XCode

<br />
<p align="center">
  <img src="https://github.com/NadeeshanEngineering/UIDropDownTextField/blob/master/Screen_Shot_02.png">
</p>
<br />

Created by Nadeeshan Jayawardana (NEngineering).
