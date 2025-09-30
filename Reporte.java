import java.util.Date;

public class Reporte {
    private String id;
    private boolean encontrado;
    private Date fecha;
    private Campus campus;
    private String numeroTelefonico;
    private String correo;
    private String descripcion;
    private Lugar lugar;

    public Reporte(String id, Date fecha, Campus campus, String numeroTelefonico, String correo, String descripcion, Lugar lugar) {
        this.id = id;
        this.encontrado = false;
        this.fecha = fecha;
        this.campus = campus;
        this.numeroTelefonico = numeroTelefonico;
        this.correo = correo;
        this.descripcion = descripcion;
        this.lugar = lugar;
    }

    public String getId() {
        return id;
    }

    public boolean isEncontrado() {
        return encontrado;
    }

    public Date getFecha() {
        return fecha;
    }

    public Campus getCampus() {
        return campus;
    }

    public String getNumeroTelefonico() {
        return numeroTelefonico;
    }

    public String getCorreo() {
        return correo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public Lugar getLugar() {
        return lugar;
    }

    public void setEncontrado(boolean encontrado) {
        this.encontrado = encontrado;
    }
}


