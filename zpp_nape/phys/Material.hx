package zpp_nape.phys;
import zpp_nape.Const;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.ID;
import zpp_nape.constraint.Constraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.FeatureMix;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.phys.FluidProperties;
import zpp_nape.phys.Compound;
import zpp_nape.callbacks.OptionType;
import zpp_nape.phys.Body;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.callbacks.Callback;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.Listener;
import zpp_nape.geom.GeomPoly;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Convex;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.AABB;
import zpp_nape.geom.Simple;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.VecMath;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.Geom;
import zpp_nape.shape.Circle;
import zpp_nape.geom.Collide;
import zpp_nape.shape.Shape;
import zpp_nape.shape.Edge;
import zpp_nape.space.Broadphase;
import zpp_nape.shape.Polygon;
import zpp_nape.space.SweepPhase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.dynamics.Contact;
import zpp_nape.space.Space;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.dynamics.InteractionGroup;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.util.Array2;
import zpp_nape.util.Lists;
import zpp_nape.util.Flags;
import zpp_nape.util.Queue;
import zpp_nape.util.Debug;
import zpp_nape.util.FastHash;
import zpp_nape.util.RBTree;
import zpp_nape.util.Pool;
import zpp_nape.util.Names;
import zpp_nape.util.Circular;
import zpp_nape.util.WrapLists;
import zpp_nape.util.Math;
import zpp_nape.util.UserData;
import nape.TArray;
import zpp_nape.util.DisjointSetForest;
import nape.Config;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.constraint.Constraint;
import nape.constraint.UserConstraint;
import nape.constraint.DistanceJoint;
import nape.constraint.LineJoint;
import nape.constraint.LinearJoint;
import nape.constraint.ConstraintList;
import nape.constraint.AngleJoint;
import nape.constraint.MotorJoint;
import nape.constraint.ConstraintIterator;
import nape.phys.GravMassMode;
import nape.phys.BodyList;
import nape.phys.Interactor;
import nape.phys.InertiaMode;
import nape.phys.InteractorList;
import nape.constraint.PulleyJoint;
import nape.phys.MassMode;
import nape.phys.Material;
import nape.phys.InteractorIterator;
import nape.phys.FluidProperties;
import nape.phys.BodyIterator;
import nape.phys.Compound;
import nape.phys.CompoundList;
import nape.phys.BodyType;
import nape.phys.CompoundIterator;
import nape.callbacks.InteractionListener;
import nape.callbacks.OptionType;
import nape.callbacks.PreListener;
import nape.callbacks.BodyListener;
import nape.callbacks.ListenerIterator;
import nape.callbacks.CbType;
import nape.callbacks.ListenerType;
import nape.callbacks.PreFlag;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ListenerList;
import nape.callbacks.ConstraintListener;
import nape.phys.Body;
import nape.callbacks.BodyCallback;
import nape.callbacks.CbTypeList;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.Callback;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.Listener;
import nape.geom.Mat23;
import nape.geom.ConvexResultIterator;
import nape.geom.GeomPoly;
import nape.geom.Ray;
import nape.geom.GeomPolyIterator;
import nape.geom.Vec2Iterator;
import nape.geom.RayResult;
import nape.geom.Winding;
import nape.geom.Vec2List;
import nape.geom.RayResultIterator;
import nape.geom.AABB;
import nape.geom.IsoFunction;
import nape.geom.GeomVertexIterator;
import nape.geom.ConvexResult;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.geom.RayResultList;
import nape.geom.Vec3;
import nape.geom.MatMN;
import nape.geom.ConvexResultList;
import nape.geom.MarchingSquares;
import nape.shape.Circle;
import nape.geom.Geom;
import nape.shape.ValidationResult;
import nape.shape.ShapeIterator;
import nape.shape.Polygon;
import nape.shape.Edge;
import nape.shape.Shape;
import nape.shape.EdgeList;
import nape.shape.EdgeIterator;
import nape.shape.ShapeList;
import nape.shape.ShapeType;
import nape.space.Broadphase;
import nape.dynamics.Contact;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.Arbiter;
import nape.dynamics.InteractionGroup;
import nape.space.Space;
import nape.dynamics.ContactIterator;
import nape.dynamics.ArbiterList;
import nape.dynamics.InteractionFilter;
import nape.dynamics.ArbiterIterator;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.FluidArbiter;
import nape.dynamics.ContactList;
import nape.dynamics.ArbiterType;
import nape.dynamics.CollisionArbiter;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.util.ShapeDebug;
#if nape_swc@:keep #end
class ZPP_Material{
    public var next:ZPP_Material=null;
    static public var zpp_pool:ZPP_Material=null;
    #if NAPE_POOL_STATS 
    /**
     * @private
     */
    static public var POOL_CNT:Int=0;
    /**
     * @private
     */
    static public var POOL_TOT:Int=0;
    /**
     * @private
     */
    static public var POOL_ADD:Int=0;
    /**
     * @private
     */
    static public var POOL_ADDNEW:Int=0;
    /**
     * @private
     */
    static public var POOL_SUB:Int=0;
    #end
    
    public var userData:Dynamic<Dynamic>=null;
    public var outer:Material=null;
    public function wrapper(){
        if(outer==null){
            outer=new Material();
            {
                var o=outer.zpp_inner;
                {
                    #if(NAPE_ASSERT&&!NAPE_RELEASE_BUILD)
                    var res={
                        o!=null;
                    };
                    if(!res)throw "assert("+"o!=null"+") :: "+("Free(in T: "+"ZPP_Material"+", in obj: "+"outer.zpp_inner"+")");
                    #end
                };
                o.free();
                o.next=ZPP_Material.zpp_pool;
                ZPP_Material.zpp_pool=o;
                #if NAPE_POOL_STATS ZPP_Material.POOL_CNT++;
                ZPP_Material.POOL_SUB++;
                #end
            };
            outer.zpp_inner=this;
        }
        return outer;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function free(){
        outer=null;
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function alloc(){}
    public var shapes:ZNPList_ZPP_Shape=null;
    public var wrap_shapes:ShapeList=null;
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function feature_cons(){
        shapes=new ZNPList_ZPP_Shape();
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function addShape(shape:ZPP_Shape){
        shapes.add(shape);
    }
    #if NAPE_NO_INLINE#elseif(flash9&&flib)@:ns("flibdel")#end
    public#if NAPE_NO_INLINE#else inline #end
    function remShape(shape:ZPP_Shape){
        shapes.remove(shape);
    }
    public var dynamicFriction:Float=0.0;
    public var staticFriction:Float=0.0;
    public var density:Float=0.0;
    public var elasticity:Float=0.0;
    public var rollingFriction:Float=0.0;
    public function new(){
        feature_cons();
        elasticity=0;
        dynamicFriction=1;
        staticFriction=2;
        density=0.001;
        rollingFriction=0.01;
    }
    public function copy(){
        var ret=new ZPP_Material();
        ret.dynamicFriction=dynamicFriction;
        ret.staticFriction=staticFriction;
        ret.density=density;
        ret.elasticity=elasticity;
        ret.rollingFriction=rollingFriction;
        return ret;
    }
    public function set(x:ZPP_Material){
        dynamicFriction=x.dynamicFriction;
        staticFriction=x.staticFriction;
        density=x.density;
        elasticity=x.elasticity;
        rollingFriction=x.rollingFriction;
    }
     public static var WAKE=1;
     public static var PROPS=2;
     public static var ANGDRAG=4;
     public static var ARBITERS=8;
    public function invalidate(x:Int){
        {
            var cx_ite=shapes.begin();
            while(cx_ite!=null){
                var s=cx_ite.elem();
                s.invalidate_material(x);
                cx_ite=cx_ite.next;
            }
        };
    }
}
