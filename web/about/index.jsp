<%-- 
    Document   : index.jsp
    Created on : Aug 20, 2008, 6:52:00 PM
    Author     : James A Hill - augman85@gmail.com
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%
request.setAttribute("pageTitle", "About");
%><%@include file="../header.jsp"%>

<ul>
    <li><a href="#goal">What is the project goal?</a></li>
    <li><a href="#work">How does this work?</a></li>
    <li><a href="#secure">How secure is this tool?</a></li>
    <li><a href="#why">Why should you use this?</a></li>
    <li><a href="#cost">How much does it cost?</a></li>
    <li><a href="#cost">History</a></li>
  </ul>

<p>The Tranche Project is a free and open source file sharing tool that enables collections of computers to easily share and cite scientific data sets. Designed and built with scientists and researchers in mind, Tranche essentially solves the data sharing problem in a secure and scalable fashion.</p>

<p>Scientific tools and data sets are helpful for validating published work, designing software algorithms, aiding current research, and much more. However, sharing large amounts of scientific data is not currently an easy task. Sometimes data is too large to share via e-mail or on a web server. Sometimes data disappears due to an individual leaving a group, or a server crashing. Sometimes data is too hard to find. And sometimes, data isn't shared because some level of confidentiality or restricted access must be guaranteed. The Tranche tool solves these issues and removes the obstacles commonly inherent in scientific data sharing.</p>

<h2>What is the project goal?<a name="goal"></a></h2>

<p>This project's goal is to solve the problems commonly associated with sharing scientific data, letting you and your collaborators focus on using the data.</p>

<h2>How does this work?<a name="work"></a></h2>

<p>In a nutshell, we are using secure distributed file sharing network concepts mixed with modern encryption to make a secure distributed file system that is well-suited for any size data and independent of any particular centralized authority.</p>

<h2>How secure is this tool?<a name="secure"></a></h2>

<p>This project uses the exact same encryption as modern e-commerce websites (i.e. on-line banks, stores, etc.). This encryption allows you to know exactly who published data to the network (i.e. can you trust the data). It also allows the network to prevent illicit data from ever getting published and shared across the network. You can also easily share pre-publication data securely with your collaborators without others being able to access it. You have the option to lock or unlock your data, and can revoke your posted data from the network at any time.</p>

<h2>Why should you use this?<a name="why"></a></h2>

<p>The easy answer is because it is designed to work for scientific data sharing, and it works in a fashion that is compatible with any programming language or operating system. The examples of use provide many illustrations of how this project can work to help you more easily share and access data.

<h2>How much does it cost?<a name="cost"></a></h2>

<p>The cost to you is nothing. This project is open source, sponsored by the National Center for Resource Research (NCRR), and it is free to use both commercially and non-commercially.</p>

<h2>What is the history of Tranche?<a name="history"></a></h2>

<p>The Tranche project started as part of <a href="http://jayson.falkfalk.com">Jayson Falkner's</a> PhD work at the University of Michigan, Ann Arbor, in 2005. The work was done as part of the National Resource for Proteomics and Pathways (Grant# P41 RR018627), directed by <a href="http://www2.ritc.med.umich.edu/?q=andrews" target="_blank">Philip C. Andrews</a>. Early versions of Tranche were used to aid in the collection of data for the ABRF sPRG 2006 study, and the first version of the Tranche project was presented at the 2006 ASMS in Seattle, WA.</p>

<p>Tranche quickly became a widely used solution to the data sharing problem in proteomics. Several proteomics journals have made recommendations that require data sharing and Tranche provides an ideal, free-to-use solution, which is supported a recommendation for use in <a href="http://www.nature.com/nbt/index.html" target="_blank">Nature Biotechnology</a>&sup1;. Currently more than 5,200 data sets are on-line, including over 10 million files and multiple terabytes of data.</p>

<p>Tranche has been used by several other proteomics resources, including the <a href="http://www.proteomecommons.org/data.jsp">ProteomeCommons.org data pages</a>. The <a href="http://www.humanproteinpedia.org/index_html" target="_blank">Human Proteinpedia</a>&sup2; project is another example use that annotates proteomics information and links to raw data stored in Tranche. The University of Vanderbilt's Medical Center also uses Tranche to archive several data sets related to its bioinformatics tools, primarily work done by David Tabb. A complete list of similar collaborations can be found at <a href="http://tranche.proteomecommons.org/examples">http://tranche.proteomecommons.org/examples</a>. Several groups rely on the Tranche website to directly provide homepages for archives of data that has been collected. The National Cancer Institute (NCI) <a href="http://mousemodels.tranche.proteomecommons.org">Mouse Models</a> and <a href="http://cptac.tranche.proteomecommons.org">CPTAC</a> initatives are two  examples of such work, but both the ABRF and HUPO organizations use Tranche in a similar fashion.</p>

<p>Most recently, use of Tranche has spread from proteomics to other disciplines of science, including glycomics, metabalomics, and 2D gel data. However, the ProteomeCommons.org Tranche Network still primarily consists of tandem mass spectrometry proteomics data. Development and support of the Tranche codebase and tools continues to be provided by the University of Michigan.  The entire Tranche project is open-source, free to use, and anyone may participate in development of the code base.</p>
<p>Jayson Falkner graduated in 2008 and work on Tranche is continued by the Tranche group at the University of Michigan and by <a href="http://www.singleorganism.com">Single Organism Software Inc (SOSI)</a>, a company co-founded by Falkner. Commercial services related to storing data in Tranche and developing code for Tranche can be obtained from SOSI.</p>
<p>&sup1;Nat. Biotech. 25 (1), 2007.<br />
   &sup2;Mathivanan et al. Nat. Biotech. 26 (6-9), 2008.</p>

<%@include file="../footer.jsp"%>