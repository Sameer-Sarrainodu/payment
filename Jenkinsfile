@Library('jenkins-shared-Library') _

def configMap = [
    project : "roboshop"
    component : "payment"
] 

if(! env.BRANCH_NAME.equalsIgnoreCase("main")){
    paymentEksPipeline(configMap)
}
else{
    echo "Please proceed with Prod"
}