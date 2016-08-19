<?php
require_once('../connect.php');
require_once('../../CLASSES/ManualLog.php');
require_once('../../CLASSES/Groupings.php');

$class = new ManualLog(	
						NULL,	
						$_POST["employees_pk"],
						$_POST["date_log"] ." ". $_POST["time_log"],
						$_POST["reason"],
						NULL,
						NULL,
						$_POST["type"]
					);

$extra['supervisor_pk'] = $_POST['supervisor_pk'];
$data = $class->save_manual_log($extra);

$sclass = new Groupings(	
						$_POST["employees_pk"],
						NULL
					);

$supervisor = $sclass->fetch();
setcookie('commented', 'commented', time()+43200000, '/');

header("HTTP/1.0 500 Internal Server Error");
if($data['status']==true){
	date_default_timezone_set('Asia/Manila');

	require '../../PHPMailer/PHPMailerAutoload.php';

	$mail = new PHPMailer;

	$mail->isSMTP();

	//Enable SMTP debugging
	// 0 = off (for production use)
	// 1 = client messages
	// 2 = client and server messages
	$mail->SMTPDebug = 2;

	//Ask for HTML-friendly debug output
	$mail->Debugoutput = 'html';

	//Set the hostname of the mail server
	$mail->Host = 'smtp.gmail.com';
	// use
	// $mail->Host = gethostbyname('smtp.gmail.com');
	// if your network does not support SMTP over IPv6

	//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
	$mail->Port = 587;

	//Set the encryption system to use - ssl (deprecated) or tls
	$mail->SMTPSecure = 'tls';

	//Whether to use SMTP authentication
	$mail->SMTPAuth = true;

	//Username to use for SMTP authentication - use full email address for gmail
	$mail->Username = "oneteam.chrs@gmail.com";

	//Password to use for SMTP authentication
	$mail->Password = "User123456!";

	//Set who the message is to be sent from
	$mail->setFrom('Notification@chrsglobal.com', 'Integrity Notification');

	//Set an alternative reply-to address
	$mail->addReplyTo('chrsoneteam@chrsglobal.com', 'CHRS One Team');

	//Set who the message is to be sent to
	$mail->addAddress($supervisor['result'][0]['email_address'], $supervisor['result'][0]['name']);
	//$mail->AddCC('rpascual.chrs@gmail.com', 'Rafael Pascual');

	//Set the subject line
	$mail->Subject = 'Manual Log';

	//Read an HTML message body from an external file, convert referenced images to embedded,
	//convert HTML into a basic plain-text alternative body

	$url = $_SERVER['HTTP_HOST'] . "/employer/#/manual_log/confirm/" . $data['returning']['pk'];
	$template = '<div style="width:100%;">
				    <div style="margin: 0 auto;width:40%;border: solid 2px #e30000;-webkit-border-radius: 5px;-moz-border-radius: 5px;border-radius: 5px;padding: 5%;">
				        <p style="font-family:helvetica;font-size:1.5em;line-height:1.3em;margin-bottom:5px;text-align:center;">A new Manual Log requires your approval!</p>
				        <p style="text-align:center;">
				            <a href="http://'.$url.'" style="-moz-box-shadow:inset 0px 1px 0px 0px #f29c93;-webkit-box-shadow:inset 0px 1px 0px 0px #f29c93;box-shadow:inset 0px 1px 0px 0px #f29c93;background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #fe1a00), color-stop(1,#ce0100));background:-moz-linear-gradient(top, #fe1a00 5%, #ce0100 100%);background:-webkit-linear-gradient(top, #fe1a00 5%, #ce0100 100%);background:-o-linear-gradient(top, #fe1a00 5%, #ce0100 100%);background:-ms-linear-gradient(top, #fe1a00 5%, #ce0100 100%);background:linear-gradient(to bottom, #fe1a00 5%, #ce0100 100%);filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=\'#fe1a00\',endColorstr=\'#ce0100\',GradientType=0);background-color:#fe1a00;-moz-border-radius:6px;-webkit-border-radius:6px;border-radius:6px;border:1px solid #d83526;display:inline-block;cursor:pointer;color:#ffffff;font-family:Arial;font-size:15px;font-weight:bold;padding:10px 44px;text-decoration:none;text-shadow:0px 1px 0px #b23e35;">OPEN</a>
				        </p>
				    </div>
				</div>';

	$mail->Body = $template;
	$mail->IsHTML(true);
	//$mail->msgHTML(file_get_contents('../../PHPMailer/templates/timesheet/manual_log.php?uri='.$_SERVER['HTTP_HOST']."&pk=".$data['returning']['pk']), dirname(__FILE__));

	//Replace the plain text body with one created manually
	//$mail->AltBody = 'This is a plain-text message body';

	//Attach an image file
	//$mail->addAttachment('images/phpmailer_mini.png');

	//send the message, check for errors

	if (!$mail->send()) {
	    echo "Mailer Error: " . $mail->ErrorInfo;
	} else {
	    //echo "Message sent!";
	    header("HTTP/1.0 200 OK");
	}

	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?> 

