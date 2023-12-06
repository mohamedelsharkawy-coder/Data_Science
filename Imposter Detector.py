# we defined a function that make our biometric system...
# classify persons to genuines and imposters...
# according to take an input_fingerprint (parameter) and compare it with others in our database.
def project(altered_image):
    
    # used_modules :
    import os
    import cv2
    import matplotlib.pyplot as plt
    
    # create sift object --> for feature extraction and describtion (define keypoints and descriptors)
    # create flann object --> for matching algorithm 
    sift = cv2.SIFT_create() 
    flann = cv2.FlannBasedMatcher({"algorithm":0},{})
    
    # read the altered(input) image and calculate its keypoints and descriptors 
    altered_img = cv2.imread(altered_image)
    kp_altered,des_altered = sift.detectAndCompute(altered_img,None)

    # make list of all real images in real folder
    real_images = os.listdir("working_image\\real")
    
    # will be useful in classification process 
    average_list = []
    
    # algorithm :-
    # for loop --> that search for the most matching fingerprint with input_one in our database.
    # by calculating the keypoints and descriptors for each of them and match them with input_ones
    # each match between input_fingerprint and the enrolled one give us distances 
    # by sorting this distances and get the average of just the first 5 ones (themost accurate ones)
    # we will have an accurate number reoresent this matching 
    # we will repeat the same process for all the enrolled fingerprints 
    # and then we will choose the smallest value --> represent the smallest distance 
    # According to trail and error for some of genuine and imposter fingerprints 
    # we observed an accurate threshold --> 100 (the average value of the distance)
    # if average more than the threshold --> imposter ..... otherwise --> genuine 
    for real_image in real_images:
        
        # read the each enrolled image and calculate its keypoints and descriptors 
        real_img = cv2.imread("working_image\\real\\"+real_image)
        kp_real,des_real = sift.detectAndCompute(real_img,None)
        
        # matching process
        all_matches = flann.knnMatch(des_real,des_altered,k=1)
        
        # calculate the distance of each match
        distance = []
        for m in all_matches:
            distance.append(m[0].distance)
        
        # sort these distances
        distance.sort()

        # take the most accurate distances (5)
        first_5_distance = distance[:5]

        # calculate the average of them ... then append to the outter list (outside the loop)
        average_first_5_distance = sum(first_5_distance) / len(first_5_distance)
        average_list.append((real_image,average_first_5_distance))
    
    # sort this list of average and take the first one (the best one)
    # average list --> 2pair values (image,average)
    average_list.sort(key=lambda x:x[1])
    best_match_average = average_list[0][1]

    # define the threshold
    ## in case of imposter:
    if best_match_average > 100 :
        # sentences to clarify the process 
        print("There is no matching found for input_fingerprint (",altered_image,") in the database.",sep="")
        print("Imposter was defined...")
        print("You have no permission to enter!")
        
        # show the Imposter fingerprint
        plt.imshow(altered_img);plt.title("Imposter")
        plt.show()  
    
    ## in case of genuine:
    else:
        best_match_fingerprint = average_list[0][0]
        best_match_img = cv2.imread("working_image\\real\\"+best_match_fingerprint)
        
        # get the id of the Employee
        _index = best_match_fingerprint.index("_")
        employee_id = best_match_fingerprint[:_index] 
        
        # sentences to clarify the process 
        print("The best match_fingerprint for(",altered_image,")in database is ---> (",best_match_fingerprint,")",sep="")
        print("A genuine was defined with ID =",employee_id)
        print("Welcome Employee",employee_id,".... You have the permission to enter!")
        
        # show the input_fingerprint and the best match one
        plt.subplot(1,2,1);plt.imshow(altered_img);plt.title("The input image")
        plt.subplot(1,2,2);plt.imshow(best_match_img);plt.title("The best match")
        plt.show() 


# in case in genuine :
project("working_image\\altered\\12__M_Left_index_finger_CR.BMP")

# in case of imposter :
# project("working_image\imposter\\f1.png")
