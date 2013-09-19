<%-- 
    Document   : faq.jsp
    Created on : Aug 20, 2008, 6:54:44 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
request.setAttribute("pageTitle", "Frequently Asked Questions");
%><%@include file="../header.jsp"%>

<p>This is the Tranche page for answers to frequently asked questions (aka FAQ). We use this page to list the most commonly asked questions along with the normal reply. You are strongly encouraged to use this page before asking a question about Tranche.</p>

<ul>
    <li><a href="#general"><strong>General questions about Tranche</a></strong></li>
    <li><a href="#developer"><strong>Developer/IT questions about Tranche</strong></a></li>
    <li><a href="#notworking"><strong>Help! Tranche isn't working!</strong></a></li>
</ul>

<h2><a name="general"></a>General Questions About Tranche</h2>
<p>This section will help to answer those basic questions that often arise when new users work with Tranche for the first time.</p>
<ul>
	<li><a href="#noservers">My Tranche Tool says it can't find any servers. What do I do?</a></li>
    <li><a href="#howlong">How long will my data be hosted on Tranche?</a></li>
    <li><a href="#filetypes">What kinds of files and information can I upload?</a></li>
    <li><a href="#structure">How do I structure my files for upload?</a></li>
    <li><a href="#compress">Is it faster if I compress my files first?</a></li>
    <li><a href="#collaborations">How does Tranche make collaborations easier?</a></li>
    <li><a href="#password">If my data are password protected, how can I be sure only my collaborators have access?</a></li>
    <li><a href="#release">When I am ready, how do I publicly release my data?</a></li>
    <li><a href="#dataproduction">How will other investigators and funding agencies know my lab produced the data?</a></li>
    <li><a href="#annotation">How do I document the annotation for my data sets?</a></li>
    <li><a href="#delete">What if I change my mind about the data I have uploaded?</a></li>
    <li><a href="#locate">How do I find my data sets after I have uploaded them?</a></li>
    <li><a href="#multiple">Can I upload multiple versions of my data sets?</a></li>
    <li><a href="#delete">Can I retract data from the Tranche repository?</a></li>
    <li><a href="#makedir">Why do I get a single, unrecognizable file when I try to download a project?</a></li>
</ul>

<h3><a name="#noservers"></a>My Tranche Tool says it can't find any servers. What do I do?</h3>
<p>If your Tranche server is telling you that it could not find any servers on startup, first check your Internet connection. If this is fine, then the likely culprit is your firewall. You will have to work with your local network administrator to open up the default Tranche ports: 443 and 1045. Without these ports open, you will not able to use Tranche.</p>

<h3><a name="howlong"></a>How long will my data be hosted on Tranche?</h3>
<p>The intention of Tranche is to host data indefinitely.  Currently the project is funded by the Phil Andrews Lab at The University of Michigan and through various other collaborators with different grant and funding sources and will continue to operate for the foreseeable future.</p>

<h3><a name="filetypes"></a>What kinds of files and information can I upload?</h3>
<p>Any type of file can be uploaded to Tranche.  Tranche can be thought of something like a very large safety deposit box, in that it doesn't matter what you have as long as Tranche has the space for it &mdash; and with over 60 terabytes of space, and more coming online all of the time, this should not be a problem for the foreseeable future &mdash; you can upload it.</p>

<h3><a name="structure"></a>How do I structure my files for upload?</h3>
<p>Uploads to the Tranche network can be structured in any manner that you would like; however, in order to facilitate locating the exact information you are looking for, it is recommended that an upload is structured in a manner similar to the following:
Create a readme file to be placed in the folder with the data to be uploaded.  This file would contain information regarding who you are, and information as to what the rest of the uploaded folder contains.  Within this main folder it is recommended that subdirectories be created for peak lists, spectra, or for any other images/annotations that you would like to publish.</p>

<h3><a name="compress"></a>Is it faster if I compress my files first?</h3>
<p>As of right now compressing a file does not make the process faster. Tranche will auto compress the files for you and it is best to let it do that.</p>

<h3><a name="collaborations"></a>How does Tranche make collaborations easier?</h3>
<p>Tranche allows collaborators to share data and research data regardless of file size, the number of files, or the file types.  Tranche can also securely share data in pre-review before publication.  Files can be encrypted and the passphrase is only available to the original uploader and whomever they share it with.  In this way researchers can work in various locations all sharing data without worry about the security of the data being compromised.</p>

<h3><a name="password"></a>If my data are password protected, how can I be sure only my collaborators have access?</h3>
<p>The ability to decrypt data is only available to those with whom the passphrase has been shared. When data is uploaded with encryption the only individual that has access to the passphrase is the original uploader; thus, only the original uploader has the ability to allow others access to  data by sharing the passphrase with them.  Tranche uses the same encryption standards as modern E-commerce websites, e.g. your online bank, and it is unlikely that anyone will break these standards anytime in the near furture.   </p>

<h3><a name="release"></a>When I am ready, how do I publicly release my data?</h3>
<p>When you are ready to release your data you can then publicly release the passphrase so that others can then download the data.  If you would like Tranche to auto-decrypt your data after it becomes public please submit your passphrase to the <a href="mailto:proteomecommons-tranche-dev@googlegroups.com">developer's group.</a></p>

<h3><a name="dataproduction"></a>How will other investigators and funding agencies know my lab produced the data?</h3>
<p>Data can be documented and provenance shown in several different ways. The best formal way is to publish the Tranche hash within any manuscript in which you publish.  Not only does this formally prove where the data comes from, Tranche can also be used to verify the completeness of data uploads.  In addition to publication in manuscripts, a Tranche hash with a corresponding annotation, can be published on a number of websites.  For an examples please examine <a href="http://www.proteomecommons.org">ProteomeCommons.org</a>.</p>

<h3><a name="annotation"></a>How do I document the annotation for my data sets?</h3>
<p>Documenting or annotating data sets is quite easy.  ProteomeCommons.org now has an online interface that allows users to annotate their data sets.  It can be found <a href="http://www.proteomecommons.org/tags">here.</a></p>

<h3><a name="delete"></a>What if I change my mind about the data I have uploaded?</h3>
<p>Data can be deleted from the Tranche network.  We cannot guarantee however that data will be deleted from the system's of those users who have already downloaded your data.  We can guarantee that from the point that you request your data be removed no other users will be able to access your data.  To request a removal of your files please <a href="mailto:proteomecommons-core@googlegroups.com"> contact us</a>.</p>

<h3><a name="locate"></a>How do I find my data sets after I have uploaded them?</h3>
<p>In order to find data after it has been uploaded you will need the Tranche hash which corresponds to that data.  When you first upload data to the network a Tranche hash will be returned.  If this hash is lost the same data can be re-uploaded, and because this data is already on the network, Tranche will actually recognize this, skip the process of uploading the duplicate files, and return the original Tranche hash.  In addition, if the Tranche hash is lost the Browse network tool can be used to locate the data.</p>

<h3><a name="multiple"></a>Can I upload multiple versions of my data sets?</h3>
<p>Yes, multiple versions of a data set can be uploaded.  Most often this manifests itself with users first uploading a complete directory with all raw data, spectra, and any images and/or annotations.  Then the data is uploaded as an individually, returning its own hash, and the spectra is uploaded individually returning its own hash; etc.  Because Tranche is intelligently designed and all of these files have already been uploaded, Tranche will not duplicate an these files with another upload, thus saving time, while allowing for greater organization.</p>

<h3><a name="makedir"></a>Why do I get a single, unrecognizable file when I try to download a project?</h3>
<p>Make sure you tell Tranche to download projects to an existing directory. Tranche makes an index file to identify sets of files, aka Tranche "projects". You can download this index file just like any other file in Tranche. When you enter a hash in to the download tool and select where to save it one of the following two things happens. If the file exists and is a directory, the download tool tries to download a directory of files. If not, the download tool downloads the exact, single file that matches the specified hash and saves it with the name of the file you specified.</p>
<p>Take home point: tell the Tranche download tool to save files to existing directories. It won't make one for you.</p>

</ul> 

<h2><a name="developer"></a>Developer/IT Questions About Tranche</h2>
<ul>
    <li><a href="#port80">Why can't I download from Tranche servers that use port 80?</a></li>
    <li><a href="#exampleserver">What are some example configurations (minimal/mid-range/dream) and prices for buying Tranche servers?</a></li>
    <li><a href="#java">How do I force quit a java program in Mac OS X?</a></li>
</ul>

<h3><a name="port80"></a>Why can't I download from Tranche servers that use port 80?</h3>
<p>It is relatively common to firewall traffic on port 80, both incoming and outgoing traffic. Port 80 is almost always intended for HTTP servers and often firewalls attempt to either log HTTP traffic, manipulate HTTP traffic, or prevent non-HTTP traffic from going over port 80. All of these can cause problems with Tranche. What is most frustrating is that the problems seem to effect a very small number of users, and it is very difficult to diagnose this problem without running a TCP packet sniffer.</p>
<p>If you are attempting to diagnose this problem the systems are very fishy. Smaller downloads seem to work. Larger downloads may work, but sometimes you'll get a lot of errors during the download. If you are lucky, the Tranche code will catch the firewall in the act and let you know something is manipulating traffic. In general, it appears that Tranche simply doesn't work reliably. Rest assured, Tranche does work and there are a few steps you can follow to truly test this.</p>
<p>Use these steps if you want to confirm that a firewall is mucking with your Tranche traffic.</p>
<ol>
    <li>Find a Tranche download that won't work, but that you are fairly positive is on-line.</li>
    <li>Identify the network you are on. If you are at work, especially if you have a large network and dedicated admin, odds are the network's firewall is messing with incoming traffic.</li>
    <li>Move to a different network that you know doesn't have a firewall. Something such as your home internet connection is a good choice.</li>
    <li>Download the seemingly flaky download from step #1. If it works, your Tranche downloads were being manipulated -- likely because a firewall is poorly configured.</li>
</ol>
<p>The default Tranche port is 443 (also used for SSL). This port is open on most every server that has port 80 open, and  unlike the port 80, the SSL port is near impossible to manipulate with a firewall. As such most firewalls don't attempt to enforce that only SSL traffic uses port 443, and most every server happens to have port 443 open.</p>
<p>If you are setting up your own Tranche servers, please do not use port 80. Port 443 is a better choice, and if you have the luxury, use a completely made up port such as 1045. It does not matter if you know that <b><i>your</i></b> firewall isn't manipulating traffic. The issue is if another Tranche user's firewall is manipulating incoming traffic from known ports.</p>


<h3><a name="exampleserver"></a>What are some example configurations (minimal/mid-range/dream) and prices for buying Tranche servers?</h3>
<p>Believe it or not,  this question is asked often. We're pleased to offer advice on what types of servers best work with Tranche. In most every case people ask for a variety of configurations including the cheapest/minimal server, a mid-range server, and how much it would cost to buy a dream machine. <a href="faq/exampleservers.html">Here is a page</a> devoted to providing some examples of such systems and links to where you can buy them on-line.</p>
<p>Please note that Tranche does not require a brand new, dedicated server. The Tranche server code uses minimal CPU cycles and next to no RAM. The most helpful things a server can have are a fast internet connection and lots of disk space.</p>

<h3><a name="java"></a>How do I force quit a running java program in Mac OS X?</h3>

<p>If you find it necessary to force quit a java program you will need to do it through the Terminal window.  From the terminal window enter:</p>

<pre>ps A |grep -i "java"</pre>
<pre>kill -s 9 <b>pid</b></pre>

<p>Where <b>pid</b> is the processor id number - the number in the first column as shown in the graphic below.  PID's appear in sequential order, with the first java app to be launched appearing first. </p>

<p><a href="images/javakill.jpg" onclick="return popupDocument('images/javakill.jpg',503,364);" /><img src="images/javakill-thumb.jpg" class="thumb" /></a></p>

<h2><a name="notworking"></a>Help! Tranche isn't working!</h2>

<h3>Caching Issues</h3>
<p>Though it isn't common, some problems with Tranche are caused by caching issues, where a previous version of Tranche being run instead of the newest, most stable.  Luckily there is a very simple way to fix this problem.  To clear the cache and allow the newest version of Trance to be downloaded and run you must clear your browser and java webstart caches.  Depending on the browser you are using will dictate exactly where you will have to go to clear your cache.  In general; however, you will need to go to a "Preferences" or "Tools" section and look for your cache.  When it is found there should also be an option for clearing it out.</p>
<p>In order to clear out the java webstart cache you will need to get to a command line (Terminal in Mac OS X and Command Prompt in Windows).  From the command line type in:</p>
<pre>javaws -viewer</pre> 
<p>This will bring up the java webstart cache.  Clear out any old versions of Tranche.</p>
<p>You have now cleared out your browser and java cache.  Simply restart your browser and navigate to the Tranche homepage and load Tranche again.  This time the newest and most stable will be downloaded and hopefully your problem will also be fixed.</p>

<%@include file="../footer.jsp"%>