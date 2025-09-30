import java.util.Date;

public class ObjetoEncontrado {
    private String id;
    private String descripcion;
    private Date fechaIngresa;

    public ObjetoEncontrado(String id, String descripcion, Date fechaIngresa) {
        this.id = id;
        this.descripcion = descripcion;
        this.fechaIngresa = fechaIngresa;
    }

    public String getId() {
        return id;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public Date getFechaIngresa() {
        return fechaIngresa;
    }
}
